const pool = require('../config/database');

// 1. Ver todas las aprobaciones pendientes (Lo que el Gerente tiene que revisar)
const findPendientes = async () => {
    const [rows] = await pool.query(
        `SELECT ID, Personal_ID, Servicio_ID, Estatus_Aprobacion, Fecha_Registro 
         FROM tbd_aprobaciones 
         WHERE Estatus = 1 AND Estatus_Aprobacion = 'Pendiente'`
    );
    return rows;
};

// 2. Crear una solicitud de aprobación
const create = async (data) => {
    const { personal_id, servicio_id, servicio_descripcion } = data;
    const [result] = await pool.query(
        `INSERT INTO tbd_aprobaciones 
        (Personal_ID, Servicio_ID, Servicio_descripcion, Estatus_Aprobacion, Fecha_Registro, Estatus) 
        VALUES (?, ?, ?, 'Pendiente', NOW(), 1)`,
        [personal_id, servicio_id, servicio_descripcion]
    );
    return result;
};

// 3. Acción del Gerente: Aprobar o Rechazar
const cambiarEstatus = async (id, nuevoEstatus) => {
    // nuevoEstatus debe ser 'Aprobado' o 'Rechazado'
    const [result] = await pool.query(
        `UPDATE tbd_aprobaciones 
         SET Estatus_Aprobacion = ?, Fecha_Actualizacion = NOW() 
         WHERE ID = ?`,
        [nuevoEstatus, id]
    );
    return result;
};

// Ver historial (Todo lo que ya NO está pendiente)
const findHistorial = async () => {
    const [rows] = await pool.query(
        `SELECT ID, Personal_ID, Servicio_ID, Estatus_Aprobacion, Fecha_Actualizacion 
         FROM tbd_aprobaciones 
         WHERE Estatus = 1 AND Estatus_Aprobacion IN ('Aprobado', 'Rechazado')
         ORDER BY Fecha_Actualizacion DESC`
    );
    return rows;
};

module.exports = {
    findPendientes,
    create,
    cambiarEstatus,
    findHistorial
};