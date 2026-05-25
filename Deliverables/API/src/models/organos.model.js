const pool = require('../config/database');

const findAll = async () => {
  const [rows] = await pool.query('SELECT * FROM tbc_organos WHERE Estatus = 1');
  return rows;
};

const findById = async (id) => {
  const [rows] = await pool.query(
    'SELECT * FROM tbc_organos WHERE ID_Organo = ? AND Estatus = 1',
    [id]
  );
  return rows[0];
};

const create = async (data) => {
  const { Nombre, Sistema_Aparato, Requisitos, Stock, Descripcion, Funcion, Fecha_Registro } = data;
  const [result] = await pool.query(
    `INSERT INTO tbc_organos (Nombre, Sistema_Aparato, Requisitos, Stock, Descripcion, Funcion, Fecha_Registro)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [Nombre, Sistema_Aparato, Requisitos, Stock, Descripcion, Funcion, Fecha_Registro]
  );
  return result.insertId;
};

const update = async (id, data) => {
  const { Nombre, Sistema_Aparato, Requisitos, Stock, Descripcion, Funcion } = data;
  const [result] = await pool.query(
    `UPDATE tbc_organos SET Nombre = ?, Sistema_Aparato = ?, Requisitos = ?, Stock = ?, Descripcion = ?, Funcion = ? 
     WHERE ID_Organo = ?`,
    [Nombre, Sistema_Aparato, Requisitos, Stock, Descripcion, Funcion, id]
  );
  return result.affectedRows;
};

const remove = async (id) => {
  // Cambiamos DELETE por UPDATE para borrado lógico
  const [result] = await pool.query(
    'UPDATE tbc_organos SET Estatus = 0 WHERE ID_Organo = ?',
    [id]
  );
  return result.affectedRows;
};

module.exports = { findAll, findById, create, update, remove };