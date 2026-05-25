const express = require('express');
const router = express.Router();
const controller = require('../controllers/organos.controller');

router.get('/organos', controller.getAll);

router.get('/organos/:id', controller.getById);

router.post('/organos', controller.create);

router.put('/organos/:id', controller.update);

router.delete('/organos/:id', controller.remove);

module.exports = router;