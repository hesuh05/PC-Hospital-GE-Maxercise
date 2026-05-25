const SolicitudServicio = require('../models/solicitudes_servicios.model');
const Aprobacion = require('../models/aprobaciones.model');
const { generarSolicitudesMock, generarAprobacionesMock } = require('../utils/mongoSeeder');

// ==========================================
// ENDPOINT 1: POBLAR SOLICITUDES
// ==========================================
const poblarSolicitudesServiciosMongo = async (req, res) => {
  const startTime = performance.now();
  try {
    const config = {
      cantidad: parseInt(req.body.cantidad) || 50,
      servicio_id: req.body.servicio_id,
      area_id: req.body.area_id,
      estatus: req.body.estatus,
      prioridad: req.body.prioridad,
      canal_origen: req.body.canal_origen,
      con_historial: req.body.con_historial,
      autogenerar_aprobaciones: req.body.autogenerar_aprobaciones === true
    };

    const insertadosTotales = await generarSolicitudesMock(config);
    const tiempoSegundos = ((performance.now() - startTime) / 1000).toFixed(2);

    return res.status(201).json({
      message: `${insertadosTotales} solicitudes generadas exitosamente.`,
      aprobaciones_auto_generadas: config.autogenerar_aprobaciones ? 'Sí' : 'No',
      tiempo_ejecucion: `${tiempoSegundos} segundos`
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al generar solicitudes', details: error.message });
  }
};

// ==========================================
// ENDPOINT 2: POBLAR APROBACIONES
// ==========================================
const poblarAprobacionesMongo = async (req, res) => {
  const startTime = performance.now();
  try {
    const cantidadRequerida = parseInt(req.body.cantidad) || 50;
    const { estatus_aprobacion, tipo_aprobacion, urgencia, forzar_generacion_solicitudes } = req.body;

    let solicitudesTarget = [];

    if (forzar_generacion_solicitudes === true) {
      // CROSS-GENERATION INVERSA: Crear solicitudes al vuelo
      console.log('Forzando generación de solicitudes ocultas para aprobarlas...');
      await generarSolicitudesMock({ cantidad: cantidadRequerida, estatus: 'pendiente', autogenerar_aprobaciones: false });
      
      solicitudesTarget = await SolicitudServicio.find({ estatus: 'pendiente' }).sort({ _id: -1 }).limit(cantidadRequerida);
    } else {
      // FLUJO NORMAL: Buscar existentes
      solicitudesTarget = await SolicitudServicio.find({ estatus: 'pendiente' }).limit(cantidadRequerida);
      
      if (solicitudesTarget.length === 0) {
        return res.status(400).json({
          error: "Falta de dependencias jerárquicas",
          message: "No hay solicitudes de servicio pendientes en MongoDB. Ejecuta primero el endpoint de Solicitudes, o envía forzar_generacion_solicitudes: true"
        });
      }
    }

    const aprobacionesGeneradasCount = await generarAprobacionesMock(solicitudesTarget, {
      estatus_aprobacion, tipo_aprobacion, urgencia
    });

    const tiempoSegundos = ((performance.now() - startTime) / 1000).toFixed(2);

    return res.status(201).json({
      message: `${aprobacionesGeneradasCount} aprobaciones generadas y enlazadas exitosamente.`,
      advertencia: solicitudesTarget.length < cantidadRequerida ? `Solo se encontraron ${solicitudesTarget.length} solicitudes pendientes para aprobar.` : undefined,
      tiempo_ejecucion: `${tiempoSegundos} segundos`
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al generar aprobaciones', details: error.message });
  }
};

const buildPagination = (req) => {
  const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
  const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 10, 1), 100);
  const skip = (page - 1) * limit;

  return { page, limit, skip };
};

const listarSolicitudesServiciosMongo = async (req, res) => {
  try {
    const { page, limit, skip } = buildPagination(req);
    const [data, totalRegistros] = await Promise.all([
      SolicitudServicio.find().sort({ 'fechas.solicitud': -1, _id: -1 }).skip(skip).limit(limit),
      SolicitudServicio.countDocuments({})
    ]);

    return res.status(200).json({
      meta: {
        totalRegistros,
        totalPaginas: Math.ceil(totalRegistros / limit) || 1,
        paginaActual: page,
        registrosPorPagina: limit
      },
      data
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al obtener solicitudes', details: error.message });
  }
};

const listarAprobacionesMongo = async (req, res) => {
  try {
    const { page, limit, skip } = buildPagination(req);
    const [data, totalRegistros] = await Promise.all([
      Aprobacion.find().sort({ fecha_solicitud: -1, _id: -1 }).skip(skip).limit(limit),
      Aprobacion.countDocuments({})
    ]);

    return res.status(200).json({
      meta: {
        totalRegistros,
        totalPaginas: Math.ceil(totalRegistros / limit) || 1,
        paginaActual: page,
        registrosPorPagina: limit
      },
      data
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Error al obtener aprobaciones', details: error.message });
  }
};

const limpiarSolicitudesServiciosMongo = async (req, res) => {
  try {
    const resultado = await SolicitudServicio.deleteMany({});
    return res.status(200).json({
      message: 'Colección de Solicitudes de Servicios limpiada exitosamente.',
      deletedCount: resultado.deletedCount
    });
  } catch (error) {
    console.error('Error al limpiar solicitudes:', error);
    return res.status(500).json({ error: 'Error interno al intentar vaciar la colección.', details: error.message });
  }
};

const limpiarAprobacionesMongo = async (req, res) => {
  try {
    const resultado = await Aprobacion.deleteMany({});
    return res.status(200).json({
      message: 'Colección de Aprobaciones limpiada exitosamente.',
      deletedCount: resultado.deletedCount
    });
  } catch (error) {
    console.error('Error al limpiar aprobaciones:', error);
    return res.status(500).json({ error: 'Error interno al intentar vaciar la colección.', details: error.message });
  }
};

module.exports = {
  poblarSolicitudesServiciosMongo,
  poblarAprobacionesMongo,
  listarSolicitudesServiciosMongo,
  listarAprobacionesMongo,
  limpiarSolicitudesServiciosMongo,
  limpiarAprobacionesMongo
};