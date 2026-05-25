const express = require('express');
const router = express.Router();

const vistasController = require('../controllers/vistas.controller');

// El profe entrará a http://localhost:3000/gerencia/reporte-roles para calificar
router.get('/reporte', vistasController.getReporteRoles);

module.exports = router;