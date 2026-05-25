const express = require('express');
const router = express.Router();

const patologiasController = require('../controllers/patologias.controller');

router.get('/patologias', patologiasController.getAll);

router.post("/patologias", patologiasController.crearPatologia);

router.delete("/patologias/:id", patologiasController.borrarPatologia);

router.put("/patologias/:id", patologiasController.actualizarPatologia);

module.exports = router;