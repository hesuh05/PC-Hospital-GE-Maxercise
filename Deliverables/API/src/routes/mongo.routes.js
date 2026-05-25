const express = require('express');
const router = express.Router();
const QuejaSugerencia = require('../models/quejas_sugerencias.model');
const Aprobacion = require('../models/aprobaciones.model');
const SolicitudServicio = require('../models/solicitudes_servicios.model');
const seederMongoController = require('../controllers/seederMongo.controller');

// ====== SOLICITUDES Y APROBACIONES (MongoDB) ======

router.get('/mongo/servicios', seederMongoController.listarSolicitudesServiciosMongo);
router.delete('/mongo/servicios/limpiar', seederMongoController.limpiarSolicitudesServiciosMongo);
router.post('/mongo/servicios/poblar', seederMongoController.poblarSolicitudesServiciosMongo);

router.get('/mongo/aprobaciones', seederMongoController.listarAprobacionesMongo);
router.delete('/mongo/aprobaciones/limpiar', seederMongoController.limpiarAprobacionesMongo);
router.post('/mongo/aprobaciones/poblar', seederMongoController.poblarAprobacionesMongo);

// ====== QUEJAS Y SUGERENCIAS (MongoDB) ======

// POST: Crear nueva queja/sugerencia
router.post('/mongo/quejas', async (req, res) => {
    try {
        const nueva = new QuejaSugerencia(req.body);
        await nueva.save();
        res.status(201).json({ 
            mensaje: "Queja guardada en Mongo", 
            data: nueva 
        });
    } catch (e) { 
        res.status(400).json({ 
            error: "Error al guardar la queja",
            detalle: e.message 
        }); 
    }
});

// GET: Obtener todas las quejas
router.get('/mongo/quejas', async (req, res) => {
    try {
        const quejas = await QuejaSugerencia.find();
        res.status(200).json({ 
            cantidad: quejas.length,
            data: quejas 
        });
    } catch (e) {
        res.status(500).json({ 
            error: "Error al obtener quejas",
            detalle: e.message 
        });
    }
});

// GET: Obtener queja por ID
router.get('/mongo/quejas/:id', async (req, res) => {
    try {
        const queja = await QuejaSugerencia.findById(req.params.id);
        if (!queja) {
            return res.status(404).json({ error: "Queja no encontrada" });
        }
        res.status(200).json(queja);
    } catch (e) {
        res.status(500).json({ 
            error: "Error al obtener la queja",
            detalle: e.message 
        });
    }
});

// PUT: Actualizar queja por ID
router.put('/mongo/quejas/:id', async (req, res) => {
    try {
        const queja = await QuejaSugerencia.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true, runValidators: true }
        );
        if (!queja) {
            return res.status(404).json({ error: "Queja no encontrada" });
        }
        res.status(200).json({ 
            mensaje: "Queja actualizada", 
            data: queja 
        });
    } catch (e) {
        res.status(400).json({ 
            error: "Error al actualizar la queja",
            detalle: e.message 
        });
    }
});

// DELETE: Eliminar queja por ID
router.delete('/mongo/quejas/:id', async (req, res) => {
    try {
        const queja = await QuejaSugerencia.findByIdAndDelete(req.params.id);
        if (!queja) {
            return res.status(404).json({ error: "Queja no encontrada" });
        }
        res.status(200).json({ 
            mensaje: "Queja eliminada" 
        });
    } catch (e) {
        res.status(500).json({ 
            error: "Error al eliminar la queja",
            detalle: e.message 
        });
    }
});

// ====== APROBACIONES (MongoDB) ======

// POST: Crear nueva aprobación
router.post('/mongo/aprobaciones', async (req, res) => {
    try {
        const nueva = new Aprobacion(req.body);
        await nueva.save();
        res.status(201).json({ 
            mensaje: "Aprobación guardada en Mongo", 
            data: nueva 
        });
    } catch (e) { 
        res.status(400).json({ 
            error: "Error al guardar la aprobación",
            detalle: e.message 
        }); 
    }
});

// GET: Obtener aprobación por ID
router.get('/mongo/aprobaciones/:id', async (req, res) => {
    try {
        const aprobacion = await Aprobacion.findById(req.params.id);
        if (!aprobacion) {
            return res.status(404).json({ error: "Aprobación no encontrada" });
        }
        res.status(200).json(aprobacion);
    } catch (e) {
        res.status(500).json({ 
            error: "Error al obtener la aprobación",
            detalle: e.message 
        });
    }
});

// PUT: Actualizar aprobación por ID
router.put('/mongo/aprobaciones/:id', async (req, res) => {
    try {
        const aprobacion = await Aprobacion.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true, runValidators: true }
        );
        if (!aprobacion) {
            return res.status(404).json({ error: "Aprobación no encontrada" });
        }
        res.status(200).json({ 
            mensaje: "Aprobación actualizada", 
            data: aprobacion 
        });
    } catch (e) {
        res.status(400).json({ 
            error: "Error al actualizar la aprobación",
            detalle: e.message 
        });
    }
});

// DELETE: Eliminar aprobación por ID
router.delete('/mongo/aprobaciones/:id', async (req, res) => {
    try {
        const aprobacion = await Aprobacion.findByIdAndDelete(req.params.id);
        if (!aprobacion) {
            return res.status(404).json({ error: "Aprobación no encontrada" });
        }
        res.status(200).json({ 
            mensaje: "Aprobación eliminada" 
        });
    } catch (e) {
        res.status(500).json({ 
            error: "Error al eliminar la aprobación",
            detalle: e.message 
        });
    }
});

// ====== SOLICITUDES DE SERVICIOS (MongoDB) ======

// POST: Crear nueva solicitud de servicio
router.post('/mongo/servicios', async (req, res) => {
    try {
        const nueva = new SolicitudServicio(req.body);
        await nueva.save();
        res.status(201).json({ 
            mensaje: "Servicio guardado en Mongo", 
            data: nueva 
        });
    } catch (e) { 
        res.status(400).json({ 
            error: "Error al guardar el servicio",
            detalle: e.message 
        }); 
    }
});

// GET: Obtener servicio por ID
router.get('/mongo/servicios/:id', async (req, res) => {
    try {
        const servicio = await SolicitudServicio.findById(req.params.id);
        if (!servicio) {
            return res.status(404).json({ error: "Servicio no encontrado" });
        }
        res.status(200).json(servicio);
    } catch (e) {
        res.status(500).json({ 
            error: "Error al obtener el servicio",
            detalle: e.message 
        });
    }
});

// PUT: Actualizar servicio por ID
router.put('/mongo/servicios/:id', async (req, res) => {
    try {
        const servicio = await SolicitudServicio.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true, runValidators: true }
        );
        if (!servicio) {
            return res.status(404).json({ error: "Servicio no encontrado" });
        }
        res.status(200).json({ 
            mensaje: "Servicio actualizado", 
            data: servicio 
        });
    } catch (e) {
        res.status(400).json({ 
            error: "Error al actualizar el servicio",
            detalle: e.message 
        });
    }
});

// DELETE: Eliminar servicio por ID
router.delete('/mongo/servicios/:id', async (req, res) => {
    try {
        const servicio = await SolicitudServicio.findByIdAndDelete(req.params.id);
        if (!servicio) {
            return res.status(404).json({ error: "Servicio no encontrado" });
        }
        res.status(200).json({ 
            mensaje: "Servicio eliminado" 
        });
    } catch (e) {
        res.status(500).json({ 
            error: "Error al eliminar el servicio",
            detalle: e.message 
        });
    }
});

module.exports = router;