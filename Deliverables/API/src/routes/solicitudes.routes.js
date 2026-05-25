const express = require('express');
const router = express.Router();
const poblarController = require('../controllers/poblarSolicitudes.controller');
const SolicitudServicio = require('../models/solicitudes_servicios.model');

// POST: Generar/poblar datos aleatorios en MongoDB
router.post('/solicitudes-servicios/poblar', poblarController.poblarSolicitudes);

// DELETE: Limpiar la colección de MongoDB
router.delete('/solicitudes-servicios/limpiar', poblarController.limpiarSolicitudes);

// POST: Crear nueva solicitud de servicio (Mongo)
router.post('/solicitudes-servicios', async (req, res) => {
    try {
        const nueva = new SolicitudServicio(req.body);
        await nueva.save();
        res.status(201).json({ 
            mensaje: "Solicitud guardada en Mongo", 
            data: nueva 
        });
    } catch (e) { 
        res.status(400).json({ 
            error: "Error al guardar la solicitud",
            detalle: e.message 
        }); 
    }
});

// GET: Obtener todas las solicitudes (Mongo)
router.get('/solicitudes-servicios', async (req, res) => {
    try {
        const servicios = await SolicitudServicio.find();
        res.status(200).json({ 
            cantidad: servicios.length,
            data: servicios 
        });
    } catch (e) {
        res.status(500).json({ 
            error: "Error al obtener solicitudes",
            detalle: e.message 
        });
    }
});

module.exports = router;
