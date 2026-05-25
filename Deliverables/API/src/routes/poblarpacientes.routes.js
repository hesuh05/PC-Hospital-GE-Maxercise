const { Router } = require('express');
const router = Router();

// 1. IMPORTANTE: Agregamos las funciones nuevas al require
const { 
    poblarPacientesProcedimiento, 
    obtenerPacientes, 
    limpiarPacientes,
    poblarOrganos,
    poblarAreas,
    poblarInventario,
    poblarTiposPatologia,
    poblarPatologias,
    poblarAccesos,
    poblarAprobaciones,
    poblarTodo
} = require('../controllers/poblarpacientes.controller');

// 2. Definimos las rutas (Ahora sí, todas las funciones existen)
router.post('/pacientes/poblar', poblarPacientesProcedimiento);
router.get('/pacientes', obtenerPacientes);
router.delete('/pacientes/limpiar', limpiarPacientes);

// Nuevas rutas para poblar otras tablas
router.post('/organos/poblar', poblarOrganos);
router.post('/areas/poblar', poblarAreas);
router.post('/inventario/poblar', poblarInventario);
router.post('/tipos/patologia/poblar', poblarTiposPatologia);
router.post('/patologias/poblar', poblarPatologias);
router.post('/accesos/poblar', poblarAccesos);
router.post('/aprobaciones/poblar', poblarAprobaciones);
// Ruta compuesta para el prototipo de poblar todo (pacientes + resto)
router.post('/todo/poblar', poblarTodo);

module.exports = router;


