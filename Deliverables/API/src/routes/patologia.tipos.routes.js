const express = require('express');
const router = express.Router();
const controller = require('../controllers/patologia.tipos.controller');

// Rutas para el catálogo
router.get('/tipos', controller.getTipos);
router.post('/tipos', controller.createTipo);

// Rutas para la relación (Puente)
router.get('/:id/clasificacion', controller.getClasificacion);

module.exports = router;