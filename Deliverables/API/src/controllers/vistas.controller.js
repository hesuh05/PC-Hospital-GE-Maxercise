const vistasModel = require('../models/vistas.model');

const getReporteRoles = async (req, res) => {
    try {
        const datos = await vistasModel.obtenerReporteRoles();
        res.status(200).json(datos);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener la vista", error: error.message });
    }
};

module.exports = { getReporteRoles };