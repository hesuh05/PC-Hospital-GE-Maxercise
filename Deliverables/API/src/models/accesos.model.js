    const pool = require('../config/database');

    // 1. Registrar un nuevo acceso (Entrada o Salida)
    const create = async (data) => {
        const { persona_id, espacio_id, tipo, autoriza_id } = data;
        const [result] = await pool.query(
            `INSERT INTO tbd_accesos 
            (Persona_ID, Espacio_ID, Tipo, Personal_ID_Autoriza, Fecha_Registro, Estatus) 
            VALUES (?, ?, ?, ?, NOW(), 1)`,
            [persona_id, espacio_id, tipo, autoriza_id]
        );
        return result;
    };

    // 2. Obtener todos los accesos (Historial de movimientos)
    const findAll = async () => {
        const [rows] = await pool.query(
            `SELECT ID, Persona_ID, Espacio_ID, Tipo, Personal_ID_Autoriza, Fecha_Registro 
            FROM tbd_accesos 
            WHERE Estatus = 1 
            ORDER BY Fecha_Registro DESC`
        );
        return rows;
    };

    // src/models/accesos.model.js

// 1. Ver movimientos de una persona específica
const findByPersona = async (personaId) => {
    const [rows] = await pool.query(
        `SELECT ID, Espacio_ID, Tipo, Fecha_Registro, Personal_ID_Autoriza
         FROM tbd_accesos 
         WHERE Persona_ID = ? AND Estatus = 1
         ORDER BY Fecha_Registro DESC`,
        [personaId]
    );
    return rows;
};

// 2. Ver quién está en un área específica (ej. Quirófano)
const findByEspacio = async (espacioId) => {
    const [rows] = await pool.query(
        `SELECT ID, Persona_ID, Tipo, Fecha_Registro
         FROM tbd_accesos 
         WHERE Espacio_ID = ? AND Estatus = 1
         ORDER BY Fecha_Registro DESC LIMIT 50`,
        [espacioId]
    );
    return rows;
};
// Buscar accesos por rango de fechas
const findByFecha = async (fechaInicio, fechaFin) => {
    const [rows] = await pool.query(
        `SELECT ID, Persona_ID, Espacio_ID, Tipo, Fecha_Registro, Personal_ID_Autoriza 
         FROM tbd_accesos 
         WHERE Estatus = 1 
         AND Fecha_Registro BETWEEN ? AND ? 
         ORDER BY Fecha_Registro DESC`,
        [`${fechaInicio} 00:00:00`, `${fechaFin} 23:59:59`]
    );
    return rows;
};
    module.exports = { 
        create, 
        findAll,
        findByPersona,
        findByEspacio,
        findByFecha
    };