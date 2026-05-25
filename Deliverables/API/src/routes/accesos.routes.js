const express = require('express');
const router = express.Router();
const controller = require('../controllers/accesos.controller');

// Registrar un nuevo acceso (POST)
router.post('/accesos', controller.registerAcceso);

// Obtener el historial completo de accesos (GET)
router.get('/accesos', controller.getAccesos);

// Obtener accesos por persona (GET)
router.get('/accesos/persona/:id', controller.getAccesosByPersona);

// Obtener accesos por rango de fechas (GET) - USAMOS QUERY PARAMS
router.get('/accesos/fechas', controller.getAccesosByFecha);
module.exports = router;