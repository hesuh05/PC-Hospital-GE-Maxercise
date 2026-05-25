const express = require('express');
const router = express.Router();
const areasController = require('../controllers/areas.controller');

// Obtener todas las áreas activas  
router.get('/areas', areasController.readAreas);

// Crear una nueva área
router.post('/areas', areasController.createArea);

// Actualizar solo el estado de operación (Activo, Mantenimiento, Cerrado)
router.put('/areas/:id', areasController.updateArea);

// Borrado lógico
router.delete('/areas/:id', areasController.deleteArea);

module.exports = router;