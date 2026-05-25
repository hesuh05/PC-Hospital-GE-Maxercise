const pool = require('../config/database');

const patologiaTiposModel = {
    // --- CATÁLOGO (tbc_tipo_patologia) ---
    // Obtener todos los tipos disponibles
    getTipos: async () => {
        const [rows] = await pool.query('SELECT * FROM tbc_tipo_patologia WHERE Estatus = 1');
        return rows;
    },

    // Crear una nueva categoría (ej. "Oncológica")
    createTipo: async (data) => {
        const { nombre, descripcion } = data;
        const [result] = await pool.query(
            'INSERT INTO tbc_tipos_patologia (Nombre, Descripcion, Estatus) VALUES (?, ?, 1)',
            [nombre, descripcion]
        );
        return result;
    },

    // Ver todas las clasificaciones de una patología específica
    getTiposPorPatologia: async (patologiaId) => {
        const [rows] = await pool.query(
            `SELECT T.ID_Tipo_Patologia, T.Nombre, T.Descripcion 
             FROM tbc_tipo_patologia T
             INNER JOIN tbd_patologia_tipo R ON T.ID_Tipo_Patologia = R.Tipo_Patologia_ID
             WHERE R.Patologia_ID = ? AND R.Estatus = 1`,
            [patologiaId]
        );
        return rows;
    }
};

module.exports = patologiaTiposModel;