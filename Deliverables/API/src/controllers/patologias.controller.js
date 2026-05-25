const patologiasModel = require('../models/patologias.model');

const getAll = async (req, res) => {
  try {
    const patologias = await patologiasModel.findAll();
    res.status(200).json(patologias);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al obtener patologías' });
  }
};

const crearPatologia = async (req, res) => {
  try {
    const {
      nombre,
      nombre_cientifico,
      nombre_comun,
      descripcion,
      fecha_clasificacion,
      tipos_ids
    } = req.body;

    if (!nombre || !nombre_cientifico || !fecha_clasificacion) {
      return res.status(400).json({
        message: "nombre, nombre_cientifico y fecha_clasificacion son obligatorios"
      });
    }

    
    const resultado = await patologiasModel.crearPatologia({
      nombre,
      nombre_cientifico,
      nombre_comun,
      descripcion,
      fecha_clasificacion,
      tipos_ids
    });

    res.status(201).json({
      message: "Patología creada correctamente",
      id_insertado: resultado.insertId
    });

  } catch (error) {
    res.status(500).json({ message: "Error al crear patología", error });
  }
};

//Borrar patología (soft delete)

const borrarPatologia = async (req, res) => {
  try {
    const { id } = req.params;
    const resultado = await patologiasModel.borrarPatologia(id);
    res.status(200).json({
      message: "Patología borrada correctamente",
      filas_afectadas: resultado.affectedRows
    });
  } catch (error) {
    res.status(500).json({ message: "Error al borrar patología", error });
  }};

  //Actualizar patología
  // En este caso, el cliente puede enviar solo el campo que quiere actualizar, o todos.
  // Por eso, primero buscamos los datos actuales en la DB, y luego mezclamos con lo que viene en req.body.

const actualizarPatologia = async (req, res) => {
  try {
    const { id } = req.params;
    
    // 1. Buscar los datos actuales en la DB
    const patologiaActual = await patologiasModel.findById(id);

    if (!patologiaActual) {
      return res.status(404).json({ message: "Patología no encontrada" });
    }

    // 2. Mezclar datos: Si req.body tiene el dato, úsalo. Si no, usa el de la DB.
    // El operador "||" (OR) hace este trabajo perfectamente.
    const datosActualizados = {
      nombre: req.body.nombre || patologiaActual.Nombre,
      nombre_cientifico: req.body.nombre_cientifico || patologiaActual.Nombre_Cientifico,
      nombre_comun: req.body.nombre_comun || patologiaActual.Nombre_Comun,
      descripcion: req.body.descripcion || patologiaActual.Descripcion
    };

    // 3. Mandar los datos mezclados al modelo
    const resultado = await patologiasModel.actualizarPatologia(id, datosActualizados);

    res.status(200).json({
      message: "Patología actualizada correctamente",
      cambios: datosActualizados // Opcional: mostrar qué quedó guardado
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al actualizar patología", error });
  }
};


module.exports = {
  getAll,
  crearPatologia,
  borrarPatologia,
  actualizarPatologia

};