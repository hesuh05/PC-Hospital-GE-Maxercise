const inventarioModel = require('../models/organosInventario.model');

const getAll = async (req, res) => {
  try {
    const data = await inventarioModel.findAll();
    res.json(data);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener inventario', error });
  }
};

const create = async (req, res) => {
  try {
    const { Organo_ID, Fecha_Expiracion, Estado } = req.body;
    if (!Organo_ID || !Fecha_Expiracion || !Estado) {
      return res.status(400).json({ message: 'Organo_ID, Fecha_Expiracion y Estado son obligatorios' });
    }
    const id = await inventarioModel.create(req.body);
    res.status(201).json({ message: 'Registro de inventario creado', id });
  } catch (error) {
    res.status(500).json({ message: 'Error al crear registro', error });
  }
};

const update = async (req, res) => {
  try {
    const { id } = req.params;
    const actual = await inventarioModel.findById(id);
    if (!actual) return res.status(404).json({ message: 'Registro no encontrado' });

    const datosNuevos = {
      Organo_ID: req.body.Organo_ID || actual.Organo_ID,
      Fecha_Expiracion: req.body.Fecha_Expiracion || actual.Fecha_Expiracion,
      Estado: req.body.Estado || actual.Estado,
      Raza: req.body.Raza || actual.Raza,
      Grupo_Sanguineo: req.body.Grupo_Sanguineo || actual.Grupo_Sanguineo,
      Observaciones: req.body.Observaciones || actual.Observaciones
    };

    await inventarioModel.update(id, datosNuevos);
    res.json({ message: 'Inventario actualizado correctamente' });
  } catch (error) {
    res.status(500).json({ message: 'Error al actualizar', error });
  }
};

const remove = async (req, res) => {
  try {
    await inventarioModel.remove(req.params.id);
    res.json({ message: 'Registro marcado como inactivo (borrado lógico) - BORRADO EXITOSO' });
  } catch (error) {
    res.status(500).json({ message: 'Error al eliminar', error });
  }
};

module.exports = { getAll, create, update, remove };