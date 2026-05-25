const { fakerES_MX: faker } = require('@faker-js/faker');
const pool = require('../config/database');
const { inicializarCatalogos, inicializarServicios } = require('./dbSeeder');
const { diccionariosServicios } = require('./serviceDictionary');
const SolicitudServicio = require('../models/solicitudes_servicios.model');
const Aprobacion = require('../models/aprobaciones.model');

// ==========================================
// UTILIDAD: OBTENER DATOS BASE MYSQL
// ==========================================
const obtenerDatosBaseMySQL = async () => {
  let [serviciosRows] = await pool.query(`SELECT s.ID, s.Nombre, s.Costo, s.Area_ID, a.Nombre as Area_Nombre FROM tbc_ge_servicios s LEFT JOIN tbc_ge_areas a ON s.Area_ID = a.ID WHERE s.Estatus = 1`);
  let [personasRows] = await pool.query(`SELECT ID, CONCAT(nombre, ' ', primer_apellido) AS nombre_completo FROM tbb_hr_personas_fisicas WHERE estatus = 1`);
  let [personalRows] = await pool.query(`SELECT p.ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo FROM tbb_hr_personal p INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID WHERE p.Estatus = 1`);

  if (serviciosRows.length === 0 || personasRows.length === 0 || personalRows.length === 0) {
    console.log('Faltan datos base en MySQL. Ejecutando inicializadores...');
    await inicializarCatalogos();
    await inicializarServicios();
    
    // Recargar datos tras sembrar
    [serviciosRows] = await pool.query(`SELECT s.ID, s.Nombre, s.Costo, s.Area_ID, a.Nombre as Area_Nombre FROM tbc_ge_servicios s LEFT JOIN tbc_ge_areas a ON s.Area_ID = a.ID WHERE s.Estatus = 1`);
    [personasRows] = await pool.query(`SELECT ID, CONCAT(nombre, ' ', primer_apellido) AS nombre_completo FROM tbb_hr_personas_fisicas WHERE estatus = 1`);
    [personalRows] = await pool.query(`SELECT p.ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo FROM tbb_hr_personal p INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID WHERE p.Estatus = 1`);
  }
  return { serviciosRows, personasRows, personalRows };
};

// ==========================================
// GENERADOR CENTRAL DE APROBACIONES
// ==========================================
const generarAprobacionesMock = async (solicitudes, config) => {
  const { personalRows } = await obtenerDatosBaseMySQL();
  const aprobacionesGeneradas = [];
  const { estatus_aprobacion, tipo_aprobacion, urgencia } = config;

  for (const sol of solicitudes) {
    const aprobador = faker.helpers.arrayElement(personalRows);
    const tipoReal = tipo_aprobacion || faker.helpers.arrayElement(["medica", "financiera", "administrativa"]);
    const estatusReal = estatus_aprobacion || faker.helpers.arrayElement(["aprobado", "rechazado"]);
    
    const diccArea = diccionariosServicios[sol.area.nombre] || diccionariosServicios["General"];
    const comentarioElegido = faker.helpers.arrayElement(diccArea.aprobaciones[estatusReal]);

    const docAprobacion = {
      solicitud_id: sol._id,
      folio_solicitud: sol.folio,
      entidad: {
        id: sol.servicio.id,
        tipo: 'SolicitudServicio',
        folio: sol.folio
      },
      solicitante: {
        id: sol.solicitante.id,
        nombre: sol.solicitante.nombre
      },
      estatus: estatusReal,
      nivel: 1,
      comentario: comentarioElegido,
      fecha_solicitud: new Date(sol.fechas?.solicitud || Date.now()),
      fecha_respuesta: estatusReal === 'pendiente' ? undefined : new Date(),
      aprobador: {
        id: aprobador.ID,
        nombre: aprobador.nombre_completo
      }
    };
    aprobacionesGeneradas.push(docAprobacion);

    // ====================================================================
    // COHERENCIA CRUZADA: ACTUALIZACIÓN DEL EXPEDIENTE ORIGINAL
    // ====================================================================
    // Solo tocamos la solicitud original si estaba "pendiente" y esperando respuesta.
    // (Si ya estaba avanzada por la Capa 1 del otro endpoint, no la alteramos).
    if (sol.estatus === 'pendiente') {
      let nuevoEstatus = sol.estatus;
      const fechaActualizacion = docAprobacion.fecha_respuesta || new Date();

      // Regla de negocio: Aprobado avanza, Rechazado muere.
      if (estatusReal === 'aprobado') {
        nuevoEstatus = 'en_proceso';
      } else if (estatusReal === 'rechazado') {
        nuevoEstatus = 'cancelado';
      }

      if (nuevoEstatus !== sol.estatus) {
        // Preparamos los campos de fecha dinámicos (si se cancela, se cierra)
        const camposSet = {
          estatus: nuevoEstatus,
          'fechas.actualizacion': fechaActualizacion
        };

        if (nuevoEstatus === 'cancelado') {
          camposSet['fechas.cierre'] = fechaActualizacion;
        }

        // Ejecutamos la actualización dejando la huella de auditoría perfecta
        await SolicitudServicio.updateOne(
          { _id: sol._id },
          {
            $set: camposSet,
            $push: {
              historial_estatus: {
                estatus: nuevoEstatus,
                fecha: fechaActualizacion,
                usuario_id: aprobador.ID,
                usuario_nombre: aprobador.nombre_completo,
                comentario: `Resolución de Aprobación: ${comentarioElegido}`
              }
            }
          }
        );
      }
    }
  }

  if (aprobacionesGeneradas.length > 0) {
    await Aprobacion.insertMany(aprobacionesGeneradas);
  }
  return aprobacionesGeneradas.length;
};

// ==========================================
// GENERADOR CENTRAL DE SOLICITUDES
// ==========================================
const generarSolicitudesMock = async (config) => {
  const { cantidad, servicio_id, area_id, estatus, prioridad, canal_origen, con_historial, autogenerar_aprobaciones } = config;
  const { serviciosRows, personasRows, personalRows } = await obtenerDatosBaseMySQL();

  let serviciosTarget = [...serviciosRows];
  if (servicio_id) serviciosTarget = serviciosTarget.filter(s => s.ID === parseInt(servicio_id));
  if (area_id && !servicio_id) serviciosTarget = serviciosTarget.filter(s => s.Area_ID === parseInt(area_id));
  
  if (serviciosTarget.length === 0) throw new Error("Filtros de Área/Servicio no coinciden con registros en MySQL.");

  const BATCH_SIZE = 5000;
  let insertadosTotales = 0;
  const timestampBatch = Date.now().toString(36).toUpperCase();
  const jerarquiaEstatus = ["pendiente", "en_proceso", "completado"];

  for (let i = 0; i < cantidad; i += BATCH_SIZE) {
    const documentos = [];
    const limite = Math.min(i + BATCH_SIZE, cantidad);

    for (let j = i; j < limite; j++) {
      const servicioSeleccionado = faker.helpers.arrayElement(serviciosTarget);
      const solicitante = faker.helpers.arrayElement(personasRows);
      
      const diccArea = diccionariosServicios[servicioSeleccionado.Area_Nombre] || diccionariosServicios["General"];

      const finalPrioridad = prioridad || faker.helpers.arrayElement(["baja", "media", "alta", "urgente"]);
      const finalCanal = canal_origen || faker.helpers.arrayElement(["web", "telefono", "presencial"]);
      let finalEstatus = estatus || faker.helpers.arrayElement(["pendiente", "en_proceso", "completado", "cancelado"]);

      let generarHistorial = con_historial !== 'no' && finalEstatus !== 'pendiente';
      
      let fechaActual = faker.date.recent({ days: 60 });
      const fechaSolicitud = new Date(fechaActual);
      let fechaActualizacion = fechaSolicitud;
      let fechaCierre = null;
      const historialArray = [];

      const targetIndex = finalEstatus === "cancelado" ? 0 : jerarquiaEstatus.indexOf(finalEstatus);

      if (generarHistorial && (targetIndex > 0 || finalEstatus === "cancelado")) {
        const pasos = finalEstatus === "cancelado" ? ["pendiente", "cancelado"] : jerarquiaEstatus.slice(0, targetIndex + 1);
        
        for (const pasoEstatus of pasos) {
          fechaActual = new Date(fechaActual.getTime() + faker.number.int({ min: 1, max: 24 }) * 3600000);
          const empleadoAsignado = faker.helpers.arrayElement(personalRows);
          
          let msjHistorial = "Cambio de estado";
          if (pasoEstatus !== "pendiente") {
             msjHistorial = faker.helpers.arrayElement(diccArea.historial[pasoEstatus]);
          }

          historialArray.push({
            estatus: pasoEstatus,
            fecha: new Date(fechaActual),
            usuario_id: empleadoAsignado.ID,
            usuario_nombre: empleadoAsignado.nombre_completo,
            comentario: msjHistorial
          });

          fechaActualizacion = new Date(fechaActual);
          if (pasoEstatus === "completado" || pasoEstatus === "cancelado") fechaCierre = new Date(fechaActual);
        }
      }

      const aplicaCosto = servicioSeleccionado.Costo === 1;
      const montoUnidad = aplicaCosto ? faker.number.int({ min: 200, max: 5000 }) : 0;
      
      const doc = {
        folio: `SOL-${new Date().getFullYear()}-${timestampBatch}-${j}`,
        servicio: { id: servicioSeleccionado.ID, nombre: servicioSeleccionado.Nombre },
        solicitante: { id: solicitante.ID, nombre: solicitante.nombre_completo },
        area: { id: servicioSeleccionado.Area_ID, nombre: servicioSeleccionado.Area_Nombre },
        descripcion: faker.helpers.arrayElement(diccArea.descripciones),
        costo: { aplica: aplicaCosto, monto_unitario: montoUnidad, cantidad: 1, descuento: 0, total: montoUnidad },
        estatus: finalEstatus,
        prioridad: finalPrioridad,
        fechas: { solicitud: fechaSolicitud, actualizacion: fechaActualizacion, cierre: fechaCierre },
        canal_origen: finalCanal,
        observaciones: faker.datatype.boolean(0.6) ? faker.helpers.arrayElement(diccArea.observaciones) : "",
        participantes: [{ persona_id: solicitante.ID, nombre: solicitante.nombre_completo, rol_participacion: "Solicitante", fecha_registro: fechaSolicitud }],
        historial_estatus: historialArray
      };
      documentos.push(doc);
    }

    const docsInsertados = await SolicitudServicio.insertMany(documentos);
    insertadosTotales += docsInsertados.length;

    // =========================================================
    // CAPA 1: COHERENCIA HISTÓRICA OBLIGATORIA
    // =========================================================
    // Toda solicitud que nace avanzada debe tener su aprobación de respaldo.
    const solicitudesAvanzadas = docsInsertados.filter(doc => 
      doc.estatus === 'en_proceso' || doc.estatus === 'completado'
    );

    if (solicitudesAvanzadas.length > 0) {
      await generarAprobacionesMock(solicitudesAvanzadas, { estatus_aprobacion: 'aprobado' });
    }

    // =========================================================
    // CAPA 2: SIMULACIÓN DE TRABAJO OPCIONAL
    // =========================================================
    if (autogenerar_aprobaciones) {
      const solicitudesPendientes = docsInsertados.filter(doc => doc.estatus === 'pendiente');

      if (solicitudesPendientes.length > 0) {
        await generarAprobacionesMock(solicitudesPendientes);
      }
    }
  }

  return insertadosTotales;
};

module.exports = { generarSolicitudesMock, generarAprobacionesMock };