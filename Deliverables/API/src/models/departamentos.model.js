const pool = require('../config/database');

const findAll = async () => {
  const [rows] = await pool.query('SELECT * FROM tbc_hr_departamentos WHERE Estatus = 1');
  return rows;
};

const findById = async (id) => {
  const [rows] = await pool.query(
    'SELECT * FROM tbc_hr_departamentos WHERE ID = ? AND Estatus = 1',
    [id]
  );
  return rows[0];
};

const create = async (data) => {
  const { Nombre, Descripcion, Area_Id, Responsable_Personal_ID } = data;
  // Estatus defaults to b'1' and Fecha_Registro defaults to CURRENT_TIMESTAMP in the schema
  const [result] = await pool.query(
    `INSERT INTO tbc_hr_departamentos (Nombre, Descripcion, Area_Id, Responsable_Personal_ID)
     VALUES (?, ?, ?, ?)`,
    [Nombre, Descripcion, Area_Id, Responsable_Personal_ID]
  );
  return result.insertId;
};

const update = async (id, data) => {
  const { Nombre, Descripcion, Area_Id, Responsable_Personal_ID } = data;
  // Fetching Fecha_Actualizacion might be handled by a DB trigger, but if not, you can add it here.
  const [result] = await pool.query(
    `UPDATE tbc_hr_departamentos 
     SET Nombre = ?, Descripcion = ?, Area_Id = ?, Responsable_Personal_ID = ? 
     WHERE ID = ?`,
    [Nombre, Descripcion, Area_Id, Responsable_Personal_ID, id]
  );
  return result.affectedRows;
};

const remove = async (id) => {
  // Borrado lógico
  const [result] = await pool.query(
    'UPDATE tbc_hr_departamentos SET Estatus = 0 WHERE ID = ?',
    [id]
  );
  return result.affectedRows;
};

module.exports = { findAll, findById, create, update, remove };