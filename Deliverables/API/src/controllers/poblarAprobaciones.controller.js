const { fakerES_MX: faker } = require('@faker-js/faker');
const pool = require('../config/database');
const { inicializarCatalogos } = require('../utils/dbSeeder');
const Aprobacion = require('../models/aprobaciones.model.js');

const poblarAprobaciones = async (req, res) => {
  const startTime = performance.now();
  try {
    const cantidad = parseInt(req.body.cantidad) || 10;
    const { 
      entidad_tipo,
      estatus,
      nivel
    } = req.body;

    // 1. OBTENER DATOS BASE DE MYSQL
    let [personalRows] = await pool.query(`
      SELECT p.ID, p.Departamento_ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo 
      FROM tbb_hr_personal p
      INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID
      WHERE p.Estatus = 1
    `);

    if (personalRows.length === 0) {
      console.log('Faltan datos base. Ejecutando seeder...');
      await inicializarCatalogos();
      
      [personalRows] = await pool.query(`
        SELECT p.ID, p.Departamento_ID, CONCAT(pf.nombre, ' ', pf.primer_apellido) AS nombre_completo 
        FROM tbb_hr_personal p
        INNER JOIN tbb_hr_personas_fisicas pf ON p.ID = pf.ID
        WHERE p.Estatus = 1
      `);
    }

    if (personalRows.length < 2) {
      throw new Error("Se necesitan al menos 2 empleados para generar aprobaciones.");
    }

    // 2. TIPOS DE ENTIDADES
    const tiposEntidad = entidad_tipo ? [entidad_tipo] : ["SolicitudServicio", "Cirugia", "Traslado", "Campania", "Otro"];

    // 3. LOTES DE GENERACIÓN (5000 en 5000)
    const BATCH_SIZE = 5000;
    let insertadosTotales = 0;
    const timestampBatch = Date.now().toString(36).toUpperCase();

    for (let i = 0; i < cantidad; i += BATCH_SIZE) {
      const documentosAprobaciones = [];
      const limite = Math.min(i + BATCH_SIZE, cantidad);

      for (let j = i; j < limite; j++) {
        const solicitante = faker.helpers.arrayElement(personalRows);
        const aprobador = faker.helpers.arrayElement(personalRows.filter(p => p.ID !== solicitante.ID));
        
        const tipoEntidad = faker.helpers.arrayElement(tiposEntidad);
        const nivelAprobacion = nivel || faker.number.int({ min: 1, max: 3 });
        
        // Distribución realista de estatus: más pendientes que aprobadas/rechazadas
        const estatusRealista = ['pendiente', 'pendiente', 'pendiente', 'pendiente', 'aprobado', 'aprobado', 'aprobado', 'rechazado', 'cancelado'];
        let finalEstatus = estatus || faker.helpers.arrayElement(estatusRealista);

        const fechaSolicitud = faker.date.recent({ days: 60 });
        let fechaRespuesta = null;

        // Si tiene respuesta, la fecha es posterior a la solicitud
        if (finalEstatus !== 'pendiente') {
          const horasTranscurridas = faker.number.int({ min: 1, max: 72 });
          fechaRespuesta = new Date(fechaSolicitud.getTime() + horasTranscurridas * 60 * 60 * 1000);
        }

        const folioSeguro = `AP-${new Date().getFullYear()}-${timestampBatch}-${j}`;

        const doc = {
          entidad: {
            tipo: tipoEntidad,
            id: faker.number.int({ min: 1, max: 99999 }),
            folio: `${tipoEntidad.substring(0, 3).toUpperCase()}-${faker.number.int({ min: 100000, max: 999999 })}`
          },
          solicitante: {
            id: solicitante.ID,
            nombre: solicitante.nombre_completo
          },
          aprobador: {
            id: aprobador.ID,
            nombre: aprobador.nombre_completo
          },
          nivel: nivelAprobacion,
          estatus: finalEstatus,
          comentario: finalEstatus !== 'pendiente' 
            ? faker.lorem.sentences({ min: 1, max: 2 })
            : undefined,
          fecha_solicitud: fechaSolicitud,
          fecha_respuesta: fechaRespuesta
        };

        documentosAprobaciones.push(doc);
      }

      // Insertamos a la base de datos lote por lote
      await Aprobacion.insertMany(documentosAprobaciones);
      insertadosTotales += documentosAprobaciones.length;
      console.log(`Progreso Aprobaciones: Se han insertado ${insertadosTotales} de ${cantidad}...`);
    }

    const endTime = performance.now();
    const tiempoSegundos = ((endTime - startTime) / 1000).toFixed(2);

    return res.status(201).json({
      message: `${insertadosTotales} aprobaciones generadas exitosamente.`,
      tiempo_ejecucion: `${tiempoSegundos} segundos`,
      warning: cantidad > 1000 ? "Los datos generados han sido omitidos de la respuesta para no saturar tu cliente de red." : undefined
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al poblar las aprobaciones.', details: error.message });
  }
};

const limpiarAprobaciones = async (req, res) => {
  try {
    const resultado = await Aprobacion.deleteMany({});
    return res.status(200).json({
      message: 'Colección de Aprobaciones limpiada exitosamente.',
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
  poblarAprobaciones,
  limpiarAprobaciones
};
