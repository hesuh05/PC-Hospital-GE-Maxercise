const express = require('express');
const router = express.Router();
const QuejaSugerencia = require('../models/quejas_sugerencias.model');
const controller = require('../controllers/poblarQuejasSugerencias.controller.js');

// Generar/poblar datos aleatorios en MongoDB 
router.post('/quejas-sugerencias/poblar', controller.poblarQuejasSugerencias);

// Limpiar la colección de MongoDB
router.delete('/quejas-sugerencias/limpiar', controller.limpiarQuejasSugerencias);

router.get('/quejas-sugerencias', async (req, res) => {
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

module.exports = router;