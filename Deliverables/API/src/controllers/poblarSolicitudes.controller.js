const { fakerES_MX: faker } = require('@faker-js/faker');
const pool = require('../config/database');
const { inicializarCatalogos } = require('../utils/dbSeeder');
const SolicitudServicio = require('../models/solicitudes_servicios.model.js');

const poblarSolicitudes = async (req, res) => {
  const startTime = performance.now();
  try {
    const cantidad = parseInt(req.body.cantidad) || 10;
    const { 
      tipo_servicio,
      estatus,
      prioridad
    } = req.body;

    // 1. OBTENER DATOS BASE DE MYSQL
    let [personalRows] = await pool.query(`
      SELECT p.ID, p.Departamento_ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo 
      FROM tbb_hr_personal p
      INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID
      WHERE p.Estatus = 1
    `);

    let [servicios] = await pool.query(`
      SELECT ID, Nombre FROM tbc_ge_servicios WHERE Estatus = 1 LIMIT 50
    `);

    let [areas] = await pool.query(`
      SELECT ID, Nombre FROM tbc_ge_areas WHERE Estatus = 1 LIMIT 50
    `);

    if (personalRows.length === 0 || servicios.length === 0 || areas.length === 0) {
      console.log('Faltan datos base. Ejecutando seeder...');
      await inicializarCatalogos();
      
      [personalRows] = await pool.query(`
        SELECT p.ID, p.Departamento_ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo 
        FROM tbb_hr_personal p
        INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID
        WHERE p.Estatus = 1
      `);

      [servicios] = await pool.query(`
        SELECT ID, Nombre FROM tbc_ge_servicios WHERE Estatus = 1 LIMIT 50
      `);

      [areas] = await pool.query(`
        SELECT ID, Nombre FROM tbc_ge_areas WHERE Estatus = 1 LIMIT 50
      `);
    }

    if (personalRows.length === 0 || servicios.length === 0 || areas.length === 0) {
      throw new Error("Se necesitan datos de personal, servicios y áreas para generar solicitudes.");
    }

    // 2. LOTES DE GENERACIÓN (5000 en 5000)
    const BATCH_SIZE = 5000;
    let insertadosTotales = 0;
    const timestampBatch = Date.now().toString(36).toUpperCase();

    for (let i = 0; i < cantidad; i += BATCH_SIZE) {
      const documentosSolicitudes = [];
      const limite = Math.min(i + BATCH_SIZE, cantidad);

      for (let j = i; j < limite; j++) {
        const solicitante = faker.helpers.arrayElement(personalRows);
        const asignado = faker.datatype.boolean(0.7) ? faker.helpers.arrayElement(personalRows) : null;
        const servicio = faker.helpers.arrayElement(servicios);
        const area = faker.helpers.arrayElement(areas);
        
        // Distribución realista: más pendientes que completadas/canceladas
        const estatusRealista = ['pendiente', 'pendiente', 'pendiente', 'pendiente', 'en_proceso', 'en_proceso', 'completado', 'cancelado'];
        let finalEstatus = estatus || faker.helpers.arrayElement(estatusRealista);

        const prioridadRealista = ['baja', 'baja', 'baja', 'media', 'media', 'media', 'alta', 'urgente'];
        let finalPrioridad = prioridad || faker.helpers.arrayElement(prioridadRealista);

        const fechaSolicitud = faker.date.recent({ days: 60 });
        let fechaActualizacion = null;
        let fechaCierre = null;

        // Si está en proceso o completada, tiene fecha de actualización
        if (finalEstatus !== 'pendiente') {
          const horasIniciales = faker.number.int({ min: 1, max: 48 });
          fechaActualizacion = new Date(fechaSolicitud.getTime() + horasIniciales * 60 * 60 * 1000);

          // Si está completada, tiene fecha de cierre
          if (finalEstatus === 'completado') {
            const horasServicio = faker.number.int({ min: 1, max: 168 });
            fechaCierre = new Date(fechaActualizacion.getTime() + horasServicio * 60 * 60 * 1000);
          }
        }

        const folioSeguro = `SOL-${new Date().getFullYear()}-${timestampBatch}-${j}`;

        // Construir participantes
        const participantes = [
          {
            persona_id: solicitante.ID,
            nombre: solicitante.nombre_completo,
            rol_participacion: "Solicitante",
            fecha_registro: fechaSolicitud
          }
        ];

        if (asignado) {
          participantes.push({
            persona_id: asignado.ID,
            nombre: asignado.nombre_completo,
            rol_participacion: "Asignado",
            fecha_registro: fechaActualizacion || fechaSolicitud
          });
        }

        // Historial de estatus
        const historialEstatus = [
          {
            estatus: finalEstatus,
            fecha: fechaSolicitud,
            usuario_id: solicitante.ID,
            usuario_nombre: solicitante.nombre_completo,
            comentario: faker.lorem.sentence()
          }
        ];

        if (finalEstatus !== 'pendiente' && asignado) {
          historialEstatus.push({
            estatus: finalEstatus === 'cancelado' ? 'cancelado' : 'en_proceso',
            fecha: fechaActualizacion || fechaSolicitud,
            usuario_id: asignado.ID,
            usuario_nombre: asignado.nombre_completo,
            comentario: faker.lorem.sentence()
          });
        }

        const doc = {
          folio: folioSeguro,
          servicio: {
            id: servicio.ID,
            nombre: servicio.Nombre
          },
          solicitante: {
            id: solicitante.ID,
            nombre: solicitante.nombre_completo
          },
          area: {
            id: area.ID,
            nombre: area.Nombre
          },
          descripcion: faker.lorem.sentences({ min: 1, max: 3 }),
          costo: {
            aplica: faker.datatype.boolean(0.6),
            monto_unitario: faker.number.float({ min: 100, max: 5000, precision: 0.01 }),
            cantidad: faker.number.int({ min: 1, max: 5 }),
            descuento: faker.datatype.boolean(0.3) ? faker.number.int({ min: 0, max: 500 }) : 0
          },
          estatus: finalEstatus,
          prioridad: finalPrioridad,
          fechas: {
            solicitud: fechaSolicitud,
            actualizacion: fechaActualizacion,
            cierre: fechaCierre
          },
          canal_origen: faker.helpers.arrayElement(['web', 'telefono', 'app', 'interno', 'presencial']),
          observaciones: finalEstatus === 'cancelado' ? faker.lorem.sentence() : undefined,
          participantes: participantes,
          historial_estatus: historialEstatus
        };

        // Calcular total del costo
        if (doc.costo.aplica) {
          doc.costo.total = (doc.costo.monto_unitario * doc.costo.cantidad) - doc.costo.descuento;
        }

        documentosSolicitudes.push(doc);
      }

      // Insertamos a la base de datos lote por lote
      await SolicitudServicio.insertMany(documentosSolicitudes);
      insertadosTotales += documentosSolicitudes.length;
      console.log(`Progreso Solicitudes: Se han insertado ${insertadosTotales} de ${cantidad}...`);
    }

    const endTime = performance.now();
    const tiempoSegundos = ((endTime - startTime) / 1000).toFixed(2);

    return res.status(201).json({
      message: `${insertadosTotales} solicitudes de servicio generadas exitosamente.`,
      tiempo_ejecucion: `${tiempoSegundos} segundos`,
      warning: cantidad > 1000 ? "Los datos generados han sido omitidos de la respuesta para no saturar tu cliente de red." : undefined
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al poblar las solicitudes.', details: error.message });
  }
};

const limpiarSolicitudes = async (req, res) => {
  try {
    const resultado = await SolicitudServicio.deleteMany({});
    return res.status(200).json({
      message: 'Colección de Solicitudes de Servicios limpiada exitosamente.',
      deletedCount: resultado.deletedCount
    });
  } catch (error) {
    console.error('Error al limpiar la colección:', error);
    return res.status(500).json({ 
      error: 'Error interno al intentar vaciar la colección.', 
      details: error.message 
    });
  }
};

module.exports = {
  poblarSolicitudes,
  limpiarSolicitudes
};

