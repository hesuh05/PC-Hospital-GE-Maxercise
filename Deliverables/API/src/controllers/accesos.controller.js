const accesosModel = require('../models/accesos.model');

const registerAcceso = async (req, res) => {
    try {
        const result = await accesosModel.create(req.body);
        res.status(201).json({ message: 'Acceso registrado correctamente', id: result.insertId });
    } catch (error) {
        res.status(500).json({ message: 'Error al registrar acceso', error: error.message });
    }
};

const getAccesos = async (req, res) => {
    try {
        const rows = await accesosModel.findAll();
        res.status(200).json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener historial de accesos', error: error.message });
    }
};

// Añadir a src/controllers/accesos.controller.js

const getAccesosByPersona = async (req, res) => {
    try {
        const { id } = req.params;
        const rows = await accesosModel.findByPersona(id);
        res.status(200).json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Error al buscar movimientos', error: error.message });
    }
};

// Añadir a src/controllers/accesos.controller.js
// Filtrar por rango de fechas (ej. ?inicio=2024-01-01&fin=2024-01-31)
const getAccesosByFecha = async (req, res) => {
    try {
        const { inicio, fin } = req.query; // Usamos query params: ?inicio=2024-01-01&fin=2024-01-02
        if (!inicio || !fin) {
            return res.status(400).json({ message: 'Faltan las fechas de inicio o fin' });
        }
        const rows = await accesosModel.findByFecha(inicio, fin);
        res.status(200).json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Error al filtrar por fecha', error: error.message });
    }
};

module.exports = { 
    registerAcceso,
     getAccesos,
     getAccesosByPersona,
    getAccesosByFecha
    };