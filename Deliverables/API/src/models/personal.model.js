const pool = require('../config/database');

const findAll = async () => {
  const [rows] = await pool.query('SELECT * FROM tbb_hr_personal WHERE Estatus = 1');
  return rows;
};

const findById = async (id) => {
  const [rows] = await pool.query(
    'SELECT * FROM tbb_hr_personal WHERE ID = ? AND Estatus = 1',
    [id]
  );
  return rows[0];
};

const create = async (data) => {
  const { Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Fecha_Baja, Salario } = data;
  const [result] = await pool.query(
    `INSERT INTO tbb_hr_personal (Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Fecha_Baja, Salario, Estatus)
     VALUES (?, ?, ?, ?, ?, ?, ?, 1)`,
    [Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Fecha_Baja, Salario]
  );
  return result.insertId;
};

const update = async (id, data) => {
  const { Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Fecha_Baja, Salario } = data;
  const [result] = await pool.query(
    `UPDATE tbb_hr_personal 
     SET Departamento_ID = ?, Numero_Empleado = ?, Puesto = ?, Tipo_Contrato = ?, Fecha_Ingreso = ?, Fecha_Baja = ?, Salario = ? 
     WHERE ID = ?`,
    [Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Fecha_Baja, Salario, id]
  );
  return result.affectedRows;
};

const remove = async (id) => {
  // Borrado lógico
  const [result] = await pool.query(
    'UPDATE tbb_hr_personal SET Estatus = 0 WHERE ID = ?',
    [id]
  );
  return result.affectedRows;
};

module.exports = { findAll, findById, create, update, remove };