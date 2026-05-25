const organosModel = require('../models/organos.model');

const getAll = async (req, res) => {
  try {
    const data = await organosModel.findAll();
    res.json(data);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener órganos' });
  }
};

const getById = async (req, res) => {
  try {
    const organo = await organosModel.findById(req.params.id);
    if (!organo) {
      return res.status(404).json({ message: 'Órgano no encontrado' });
    }
    res.json(organo);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener órgano' });
  }
};

const create = async (req, res) => {
  try {
    const { Nombre, Sistema_Aparato, Stock, Fecha_Registro } = req.body;

    if (!Nombre || !Sistema_Aparato || Stock === undefined || !Fecha_Registro) {
      return res.status(400).json({
        message: 'Campos obligatorios faltantes'
      });
    }

    const id = await organosModel.create(req.body);
    res.status(201).json({ message: 'Órgano creado', id });
  } catch (error) {
    res.status(500).json({ message: 'Error al crear órgano' });
  }
};

const update = async (req, res) => {
  try {
    const { id } = req.params;
    // 1. Buscar los datos actuales
    const organoActual = await organosModel.findById(id);
    if (!organoActual) {
      return res.status(404).json({ message: 'Órgano no encontrado' });
    }

    // 2. Mezclar datos: si no viene en el body, usar lo que ya existe
    const datosActualizados = {
      Nombre: req.body.Nombre || organoActual.Nombre,
      Sistema_Aparato: req.body.Sistema_Aparato || organoActual.Sistema_Aparato,
      Requisitos: req.body.Requisitos || organoActual.Requisitos,
      Stock: req.body.Stock !== undefined ? req.body.Stock : organoActual.Stock,
      Descripcion: req.body.Descripcion || organoActual.Descripcion,
      Funcion: req.body.Funcion || organoActual.Funcion
    };

    const result = await organosModel.update(id, datosActualizados);
    res.json({ message: 'Órgano actualizado correctamente' });
  } catch (error) {
    res.status(500).json({ message: 'Error al actualizar órgano' });
  }
};

const remove = async (req, res) => {
  try {
    await organosModel.remove(req.params.id);
    res.json({ message: 'Órgano eliminado' });
  } catch (error) {
    res.status(500).json({ message: 'Error al eliminar órgano' });
  }
};

module.exports = {
  getAll,
  getById,
  create,
  update,
  remove };