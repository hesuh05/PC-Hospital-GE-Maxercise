const express = require('express');
const router = express.Router();
const controller = require('../controllers/aprobaciones.controller');
const poblarController = require('../controllers/poblarAprobaciones.controller');
const Aprobacion = require('../models/aprobaciones.model');

// 0. Generar/poblar datos aleatorios en MongoDB
router.post('/aprobaciones/poblar', poblarController.poblarAprobaciones);

// 0.1 Limpiar la colección de MongoDB
router.delete('/aprobaciones/limpiar', poblarController.limpiarAprobaciones);

// 1. Ver solicitudes pendientes (GET)
router.get('/aprobaciones/pendientes', controller.getPendientes);

// 2. Ver historial de decisiones (GET) - CAMBIAMOS LA RUTA para evitar duplicados
router.get('/aprobaciones/historial', controller.getHistorial);

// 3. Crear una nueva solicitud SQL (POST)
router.post('/aprobaciones/solicitar', controller.crearSolicitud);

// 4. Crear una nueva aprobación Mongo (POST) - comportamiento similar a quejas_sugerencias
router.post('/aprobaciones', async (req, res) => {
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

// 5. Aprobar o rechazar (PATCH)
router.patch('/aprobaciones/:id', controller.procesarAprobacion);

// GET: Obtener todas las aprobaciones (Mongo) - comportamiento similar a quejas_sugerencias
router.get('/aprobaciones', async (req, res) => {
    try {
        const aprobaciones = await Aprobacion.find();
        res.status(200).json({ 
            cantidad: aprobaciones.length,
            data: aprobaciones 
        });
    } catch (e) {
        res.status(500).json({ 
            error: "Error al obtener aprobaciones",
            detalle: e.message 
        });
    }
});

module.exports = router;