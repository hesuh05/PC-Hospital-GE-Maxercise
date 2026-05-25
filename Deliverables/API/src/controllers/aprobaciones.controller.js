const aprobacionesModel = require('../models/aprobaciones.model');

const crearSolicitud = async (req, res) => {
    try {
        // Recibes los datos del body (asegúrate de que los nombres coincidan con tu modelo)
        const result = await aprobacionesModel.create(req.body);
        res.status(201).json({ 
            message: 'Solicitud creada con éxito', 
            id: result.insertId 
        });
    } catch (error) {
        res.status(500).json({ message: 'Error al crear solicitud', error: error.message });
    }
};

const getPendientes = async (req, res) => {
    try {
        const rows = await aprobacionesModel.findPendientes();
        res.status(200).json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener pendientes', error: error.message });
    }
};

const procesarAprobacion = async (req, res) => {
    try {
        const { id } = req.params;
        const { decision } = req.body; // 'Aprobado' o 'Rechazado'
        
        await aprobacionesModel.cambiarEstatus(id, decision);
        res.status(200).json({ message: `Solicitud ${decision} con éxito` });
    } catch (error) {
        res.status(500).json({ message: 'Error al procesar la aprobación', error: error.message });
    }
};

const getHistorial = async (req, res) => {
    try {
        const rows = await aprobacionesModel.findHistorial();
        res.status(200).json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener el historial', error: error.message });
    }
};

module.exports = {
    getPendientes,
    procesarAprobacion,
    getHistorial,
    crearSolicitud
};