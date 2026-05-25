const model = require('../models/patologia.tipos.model');

const getTipos = async (req, res) => {
    try {
        const data = await model.getTipos();
        res.status(200).json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

const createTipo = async (req, res) => {
    try {
        const result = await model.createTipo(req.body);
        res.status(201).json({ message: 'Categoría creada', id: result.insertId });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

const asignarTipo = async (req, res) => {
    try {
        const { patologia_id, tipo_id } = req.body;
        await model.vincularPatologiaConTipo(patologia_id, tipo_id);
        res.status(201).json({ message: 'Patología clasificada correctamente' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

const getClasificacion = async (req, res) => {
    try {
        const { id } = req.params;
        const data = await model.getTiposPorPatologia(id);
        res.status(200).json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

module.exports = { getTipos, createTipo, asignarTipo, getClasificacion };