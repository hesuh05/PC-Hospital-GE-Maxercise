const pool = require('../config/database');

const findAll = async () => {
  const [rows] = await pool.query('SELECT * FROM tbb_hr_personas_fisicas WHERE estatus = 1');
  return rows;
};

const findById = async (id) => {
  const [rows] = await pool.query(
    'SELECT * FROM tbb_hr_personas_fisicas WHERE ID = ? AND estatus = 1',
    [id]
  );
  return rows[0];
};

const create = async (data) => {
  const { 
    titulo_cortesia, 
    nombre, 
    primer_apellido, 
    segundo_apellido, 
    genero, 
    fecha_nacimiento, 
    curp, 
    grupo_sanguineo 
  } = data;

  const [result] = await pool.query(
    `INSERT INTO tbb_hr_personas_fisicas 
      (titulo_cortesia, nombre, primer_apellido, segundo_apellido, genero, fecha_nacimiento, curp, grupo_sanguineo, estatus)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)`,
    [titulo_cortesia, nombre, primer_apellido, segundo_apellido, genero, fecha_nacimiento, curp, grupo_sanguineo]
  );
  return result.insertId;
};

const update = async (id, data) => {
  const { 
    titulo_cortesia, 
    nombre, 
    primer_apellido, 
    segundo_apellido, 
    genero, 
    fecha_nacimiento, 
    curp, 
    grupo_sanguineo 
  } = data;

  const [result] = await pool.query(
    `UPDATE tbb_hr_personas_fisicas 
     SET titulo_cortesia = ?, nombre = ?, primer_apellido = ?, segundo_apellido = ?, genero = ?, fecha_nacimiento = ?, curp = ?, grupo_sanguineo = ? 
     WHERE ID = ?`,
    [titulo_cortesia, nombre, primer_apellido, segundo_apellido, genero, fecha_nacimiento, curp, grupo_sanguineo, id]
  );
  return result.affectedRows;
};

const remove = async (id) => {
  // Borrado lógico cambiando el estatus a 0
  const [result] = await pool.query(
    'UPDATE tbb_hr_personas_fisicas SET estatus = 0 WHERE ID = ?',
    [id]
  );
  return result.affectedRows;
};

module.exports = { findAll, findById, create, update, remove };