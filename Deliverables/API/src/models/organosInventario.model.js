const pool = require('../config/database');

const findAll = async () => {
  const [rows] = await pool.query(
    `SELECT 
        i.ID_Inventario, 
        o.Nombre AS Organo_Nombre, 
        i.Fecha_Expiracion, 
        i.Estado, 
        i.Raza, 
        i.Grupo_Sanguineo,
        i.Observaciones,
        CAST(i.Estatus AS UNSIGNED) AS Estatus
     FROM tbb_organo_inventario i
     JOIN tbc_organos o ON i.Organo_ID = o.ID_Organo
     WHERE i.Estatus = 1`
  );
  return rows;
};

const findById = async (id) => {
  const [rows] = await pool.query(
    'SELECT * FROM tbb_organo_inventario WHERE ID_Inventario = ? AND Estatus = 1',
    [id]
  );
  return rows[0];
};

const create = async (data) => {
  const { Organo_ID, Fecha_Expiracion, Estado, Raza, Grupo_Sanguineo, Observaciones } = data;
  const [result] = await pool.query(
    `INSERT INTO tbb_organo_inventario 
     (Organo_ID, Fecha_Expiracion, Estado, Raza, Grupo_Sanguineo, Observaciones) 
     VALUES (?, ?, ?, ?, ?, ?)`,
    [Organo_ID, Fecha_Expiracion, Estado, Raza, Grupo_Sanguineo, Observaciones]
  );
  return result.insertId;
};

const update = async (id, data) => {
  const { Organo_ID, Fecha_Expiracion, Estado, Raza, Grupo_Sanguineo, Observaciones } = data;
  const [result] = await pool.query(
    `UPDATE tbb_organo_inventario 
     SET Organo_ID = ?, Fecha_Expiracion = ?, Estado = ?, Raza = ?, Grupo_Sanguineo = ?, Observaciones = ? 
     WHERE ID_Inventario = ?`,
    [Organo_ID, Fecha_Expiracion, Estado, Raza, Grupo_Sanguineo, Observaciones, id]
  );
  return result.affectedRows;
};

const remove = async (id) => {
  const [result] = await pool.query(
    'UPDATE tbb_organo_inventario SET Estatus = 0 WHERE ID_Inventario = ?',
    [id]
  );
  return result.affectedRows;
};

module.exports = { 
  findAll,
  findById,
  create,
  update,
  remove };