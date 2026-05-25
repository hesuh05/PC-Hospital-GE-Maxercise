const express = require('express');
const router = express.Router();

const controller = require('../controllers/organosInventario.controller');

router.get('/inventario', controller.getAll);

router.post('/inventario', controller.create);

router.put('/inventario/:id', controller.update);

router.delete('/inventario/:id', controller.remove);

module.exports = router;