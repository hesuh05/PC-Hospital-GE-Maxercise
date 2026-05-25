const areasModel = require('../models/areas.model');

const readAreas = async (req, res) => {
    try {
        const areas = await areasModel.findAll();
        res.status(200).json(areas);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener las áreas', error: error.message });
    }
};

const createArea = async (req, res) => {
    try {
        const result = await areasModel.create(req.body);
        res.status(201).json({ 
            message: 'Área creada con éxito', 
            id: result.insertId 
        });
    } catch (error) {
        res.status(500).json({ message: 'Error al crear el área', error: error.message });
    }
};

const updateArea = async (req, res) => {
    try {
        const { id } = req.params;
        // Cambiamos updateStatus por updateArea y pasamos req.body completo
        const result = await areasModel.updateArea(id, req.body);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'No se encontró el área para actualizar' });
        }

        res.status(200).json({ message: 'Área actualizada con éxito' });
    } catch (error) {
        res.status(500).json({ message: 'Error al actualizar el área', error: error.message });
    }
};

const deleteArea = async (req, res) => {
    try {
        const { id } = req.params;
        await areasModel.softDelete(id);
        res.status(200).json({ message: 'Área eliminada (Soft Delete)' });
    } catch (error) {
        res.status(500).json({ message: 'Error al eliminar área', error: error.message });
    }
};

module.exports = {
    readAreas,
    createArea,
    updateArea,
    deleteArea
};