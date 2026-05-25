const { fakerES_MX: faker } = require('@faker-js/faker');
const pool = require('../config/database');
const { inicializarCatalogos } = require('../utils/dbSeeder');
const QuejaSugerencia = require('../models/quejas_sugerencias.model.js');
const { departmentContext } = require('../utils/departmentDictionary.js')

const departamentosSeed = Object.keys(departmentContext);
console.log(departamentosSeed)

const poblarQuejasSugerencias = async (req, res) => {
  const startTime = performance.now();
  try {
    const cantidad = parseInt(req.body.cantidad) || 10;
    const { 
      tipo, 
      prioridad, 
      estatus, 
      medio_recepcion, 
      con_seguimiento,
      area_id,
      departamento_id,
      personal_id       // <-- NUEVO: ID del empleado reportado
    } = req.body;

    // 1. OBTENER DATOS BASE DE MYSQL
    let [departamentos] = await pool.query('SELECT ID, Nombre, Area_Id FROM tbc_hr_departamentos WHERE Estatus = 1');
    
    let [personasRows] = await pool.query(`
      SELECT f.ID, CONCAT(f.nombre, ' ', f.primer_apellido) AS nombre_completo 
      FROM tbb_hr_personas_fisicas f 
      LEFT JOIN tbb_hr_personal p ON f.ID = p.ID
      WHERE f.estatus = 1 AND p.ID IS NULL
    `);

    // NUEVO: Traemos el Departamento_ID del personal para cruzar validaciones
    let [personalRows] = await pool.query(`
      SELECT p.ID, p.Departamento_ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo 
      FROM tbb_hr_personal p
      INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID
      WHERE p.Estatus = 1
    `);

    if (departamentos.length === 0 || personasRows.length === 0 || personalRows.length === 0) {
      console.log('Faltan datos base. Ejecutando seeder...');
      await inicializarCatalogos();
      
      [departamentos] = await pool.query('SELECT ID, Nombre, Area_Id FROM tbc_hr_departamentos WHERE Estatus = 1');
      [personasRows] = await pool.query(`SELECT f.ID, CONCAT(f.nombre, ' ', f.primer_apellido) AS nombre_completo FROM tbb_hr_personas_fisicas f LEFT JOIN tbb_hr_personal p ON f.ID = p.ID WHERE f.estatus = 1 AND p.ID IS NULL`);
      [personalRows] = await pool.query(`SELECT p.ID, p.Departamento_ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo FROM tbb_hr_personal p INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID WHERE p.Estatus = 1`);
    }

    if (departamentos.length === 0 || personasRows.length === 0 || personalRows.length === 0) {
      throw new Error("Faltan catálogos relacionales para generar las quejas.");
    }

    // ==========================================
    // 2. LÓGICA DE VALIDACIÓN CRUZADA ESTRICTA
    // ==========================================
    let departamentosTarget = [...departamentos];
    let empleadoForzado = null;

    if (personal_id) {
      empleadoForzado = personalRows.find(p => p.ID === parseInt(personal_id));
      if (!empleadoForzado) {
        return res.status(404).json({ error: `El personal con ID ${personal_id} no existe o no está activo.` });
      }

      const deptoDelEmpleado = departamentos.find(d => d.ID === empleadoForzado.Departamento_ID);

      if (departamento_id && parseInt(departamento_id) !== deptoDelEmpleado.ID) {
        return res.status(400).json({ error: `Contradicción: El personal (ID: ${personal_id}) pertenece a '${deptoDelEmpleado.Nombre}', pero solicitaste generar datos en el departamento ID: ${departamento_id}.` });
      }

      if (area_id && parseInt(area_id) !== deptoDelEmpleado.Area_Id) {
        return res.status(400).json({ error: `Contradicción: El personal (ID: ${personal_id}) pertenece a un área distinta a la solicitada (ID: ${area_id}).` });
      }

      departamentosTarget = [deptoDelEmpleado];

    } else {
      if (area_id && departamento_id) {
        const deptoFound = departamentosTarget.find(d => d.ID === parseInt(departamento_id));
        if (!deptoFound) return res.status(404).json({ error: `Departamento ${departamento_id} no existe.` });
        if (deptoFound.Area_Id !== parseInt(area_id)) {
          return res.status(400).json({ error: `Incongruencia: El departamento '${deptoFound.Nombre}' no pertenece al área ${area_id}.` });
        }
        departamentosTarget = [deptoFound];
      } else if (departamento_id) {
        const deptoFound = departamentosTarget.find(d => d.ID === parseInt(departamento_id));
        if (!deptoFound) return res.status(404).json({ error: `Departamento no existe.` });
        departamentosTarget = [deptoFound];
      } else if (area_id) {
        departamentosTarget = departamentosTarget.filter(d => d.Area_Id === parseInt(area_id));
        if (departamentosTarget.length === 0) return res.status(404).json({ error: `No hay departamentos en el área ${area_id}.` });
      }
    }

    // ==========================================
    // PONDERACIÓN REALISTA DE DEPARTAMENTOS
    // Hospital 3er Nivel: Mayor carga en Urgencias, Consulta Externa y Farmacia
    // ==========================================
    let departamentosPonderados = [];
    for (const d of departamentosTarget) {
      if (['Urgencias', 'Consulta Externa'].includes(d.Nombre)) {
        departamentosPonderados.push(d, d, d, d, d); // 5x probabilidad
      } else if (['Farmacia', 'Laboratorio', 'Quirófano'].includes(d.Nombre)) {
        departamentosPonderados.push(d, d, d); // 3x probabilidad
      } else {
        departamentosPonderados.push(d); // 1x probabilidad (áreas administrativas/menores)
      }
    }

    // ==========================================
    // 3. GENERACIÓN DE DOCUMENTOS DE MONGODB (OPTIMIZADO PARA ALTO VOLUMEN)
    // ==========================================
    const jerarquiaEstatus = ["registrada", "en_revision", "en_proceso", "atendida", "cerrada"];
    
    // Configuramos lotes de 5000 en 5000 para no reventar la memoria RAM de Node.js
    const BATCH_SIZE = 5000;
    let insertadosTotales = 0;
    
    // Generamos un string corto basado en el tiempo exacto de ejecución para añadir entropía
    const timestampBatch = Date.now().toString(36).toUpperCase(); 

    for (let i = 0; i < cantidad; i += BATCH_SIZE) {
      const documentosQuejas = [];
      const limite = Math.min(i + BATCH_SIZE, cantidad);

      for (let j = i; j < limite; j++) {
        const depto = faker.helpers.arrayElement(departamentosPonderados);
        const usuario = faker.helpers.arrayElement(personasRows);
        
        let personalInvolucradoSeleccionado = undefined;
        
        if (empleadoForzado) {
          personalInvolucradoSeleccionado = empleadoForzado;
        } else {
          const personalDelDepto = personalRows.filter(p => p.Departamento_ID === depto.ID);
          if (faker.datatype.boolean(0.6) && personalDelDepto.length > 0) {
            personalInvolucradoSeleccionado = faker.helpers.arrayElement(personalDelDepto);
          }
        }

        const personalParaSeguimiento = personalRows.filter(p => {
          const noEsElPaciente = p.ID !== usuario.ID;
          const noEsElReportado = !personalInvolucradoSeleccionado || p.ID !== personalInvolucradoSeleccionado.ID;
          return noEsElPaciente && noEsElReportado;
        });

        const empleadoAsignadoParaSeguimiento = personalParaSeguimiento.length > 0 
          ? faker.helpers.arrayElement(personalParaSeguimiento) 
          : { ID: 9999, nombre_completo: "Sistema Automatizado" };

        const docTipo = tipo || faker.helpers.arrayElement(['queja', 'queja', 'queja', 'queja', 'sugerencia']);
        
        const estatusRealista = ['cerrada', 'cerrada', 'cerrada', 'cerrada', 'en_proceso', 'en_proceso', 'registrada', 'registrada', 'en_revision', 'atendida'];
        let finalEstatus = estatus || faker.helpers.arrayElement(estatusRealista);
        
        let generarSeguimiento = false;

        if (con_seguimiento === 'no') {
          generarSeguimiento = false;
          finalEstatus = 'registrada'; 
        } else if (con_seguimiento === 'si') {
          generarSeguimiento = true;
          if (finalEstatus === 'registrada') finalEstatus = faker.helpers.arrayElement(["en_revision", "en_proceso", "atendida", "cerrada"]);
        } else {
          if (finalEstatus === 'registrada') generarSeguimiento = false;
          else generarSeguimiento = true;
        }

        const targetIndex = jerarquiaEstatus.indexOf(finalEstatus);

        let fechaActual = faker.date.recent({ days: 60 }); 
        const registroOriginal = new Date(fechaActual);
        let fechaAtencion = null;
        let fechaCierre = null;
        const historialSeguimiento = [];

        const context = departmentContext[depto.Nombre] || departmentContext["Urgencias"]; 

        if (generarSeguimiento && targetIndex > 0) {
          for (let k = 1; k <= targetIndex; k++) {
            const estatusFase = jerarquiaEstatus[k];
            const horasTranscurridas = faker.number.int({ min: 1, max: 48 });
            fechaActual = new Date(fechaActual.getTime() + horasTranscurridas * 60 * 60 * 1000);

            historialSeguimiento.push({
              estatus: estatusFase,
              comentario: faker.helpers.arrayElement(context.comentarios_seguimiento),
              fecha: new Date(fechaActual),
              usuario_id: empleadoAsignadoParaSeguimiento.ID,
              usuario_nombre: empleadoAsignadoParaSeguimiento.nombre_completo
            });

            if (estatusFase === 'atendida') fechaAtencion = new Date(fechaActual);
            if (estatusFase === 'cerrada') fechaCierre = new Date(fechaActual);
          }
        }

        let descripcion;
        if (personalInvolucradoSeleccionado) {
          descripcion = docTipo === 'queja' 
            ? faker.helpers.arrayElement(context.quejas_personal) 
            : faker.helpers.arrayElement(context.sugerencias_personal);
        } else {
          descripcion = docTipo === 'queja' 
            ? faker.helpers.arrayElement(context.quejas) 
            : faker.helpers.arrayElement(context.sugerencias);
        }

        const respuestaFinal = targetIndex >= 3 ? faker.helpers.arrayElement(context.respuestas_finales) : undefined;

        // FOLIO BLINDADO: Evita colisiones combinando el año, un identificador de lote y el índice absoluto 'j'
        const folioSeguro = `FL-${new Date().getFullYear()}-${timestampBatch}-${j}`;

        const doc = {
          folio: folioSeguro,
          tipo: docTipo,
          categoria: faker.helpers.arrayElement(['Tiempos', 'Tiempos', 'Tiempos', 'Tiempos', 'Atención', 'Atención', 'Atención', 'Personal', 'Personal', 'Instalaciones']),
          prioridad: prioridad || faker.helpers.arrayElement(['media', 'media', 'media', 'media', 'alta', 'alta', 'alta', 'baja', 'baja', 'urgente']),
          descripcion: descripcion,
          persona_fisica: { id: usuario.ID, nombre: usuario.nombre_completo },
          departamento: { id: depto.ID, nombre: depto.Nombre },
          medio_recepcion: medio_recepcion || faker.helpers.arrayElement(['presencial', 'presencial', 'presencial', 'presencial', 'buzon', 'buzon', 'buzon', 'telefono', 'web', 'app']),
          estatus: finalEstatus,
          personal_involucrado: personalInvolucradoSeleccionado ? { 
            id: personalInvolucradoSeleccionado.ID, 
            nombre: personalInvolucradoSeleccionado.nombre_completo 
          } : undefined,
          respuesta: respuestaFinal, 
          fechas: { registro: registroOriginal, atencion: fechaAtencion, cierre: fechaCierre },
          seguimiento: historialSeguimiento
        };

        documentosQuejas.push(doc);
      }

      // Insertamos a la base de datos lote por lote
      await QuejaSugerencia.insertMany(documentosQuejas); 
      insertadosTotales += documentosQuejas.length;
      console.log(`Progreso: Se han insertado ${insertadosTotales} de ${cantidad}...`);
    }

    const endTime = performance.now();
    const tiempoSegundos = ((endTime - startTime) / 1000).toFixed(2); // Convertimos a segundos con 2 decimales

    // Retornamos la respuesta SIN el arreglo gigantesco, pero CON el tiempo
    return res.status(201).json({
      message: `${insertadosTotales} registros generados exitosamente.`,
      tiempo_ejecucion: `${tiempoSegundos} segundos`, // <-- AQUÍ ESTÁ LA MAGIA
      warning: cantidad > 1000 ? "Los datos generados han sido omitidos de la respuesta para no saturar tu cliente de red." : undefined
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al poblar los datos.', details: error.message });
  }
};

const limpiarQuejasSugerencias = async (req, res) => {
  try {
    const resultado = await QuejaSugerencia.deleteMany({});
    return res.status(200).json({
      message: 'Colección de Quejas y Sugerencias limpiada exitosamente.',
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
  poblarQuejasSugerencias,
  limpiarQuejasSugerencias
};