const pool = require('../config/database');

// 1. Obtener todas las patologías (Cumple con mostrar la clasificación)
const findAll = async () => {
    const [rows] = await pool.query(
        `SELECT 
            p.ID_Patologia,
            p.Nombre,
            p.Nombre_Cientifico,
            p.Nombre_Comun,
            p.Descripcion,
            p.Estatus_Patologia,
            GROUP_CONCAT(tp.Nombre SEPARATOR ', ') AS Clasificaciones
         FROM tbc_ge_patologias p
         LEFT JOIN tbd_patologias_tipos rel ON p.ID_Patologia = rel.Patologia_ID
         LEFT JOIN tbc_ge_tipos_patologia tp ON rel.Tipo_Patologia_ID = tp.ID_Tipo_Patologia
         WHERE p.Estatus_Patologia = 1
         GROUP BY p.ID_Patologia`
    );
    return rows;
};

// 2. Crear patología (CUMPLE EL REQUISITO DE "VARIOS TIPOS")
const crearPatologia = async (data) => {
    const {
        nombre,
        nombre_cientifico,
        nombre_comun,
        descripcion,
        fecha_clasificacion,
        tipos_ids // Array de IDs de tipos, ej: [1, 2]
    } = data;

    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        // Insertar en tabla maestra
        const [resultado] = await connection.query(
            `INSERT INTO tbc_patologias
            (Nombre, Nombre_Cientifico, Nombre_Comun, Descripcion, Fecha_Clasificacion)
            VALUES (?, ?, ?, ?, ?)`,
            [nombre, nombre_cientifico, nombre_comun, descripcion, fecha_clasificacion]
        );

        const patologiaId = resultado.insertId;

        // Insertar en tabla intermedia (Relación Muchos a Muchos)
        if (tipos_ids && tipos_ids.length > 0) {
            const valoresRelacion = tipos_ids.map(tipoId => [patologiaId, tipoId]);
            await connection.query(
                `INSERT INTO tbd_patologias_tipos (Patologia_ID, Tipo_Patologia_ID) VALUES ?`,
                [valoresRelacion]
            );
        }

        await connection.commit();
        return resultado;
    } catch (error) {
        await connection.rollback();
        throw error;
    } finally {
        connection.release();
    }
};

// 3. Buscar por ID (La función que te faltaba y causaba el error)
const findById = async (id) => {
    const [rows] = await pool.query(
        'SELECT * FROM tbc_patologias WHERE ID_Patologia = ? AND Estatus_Patologia = 1',
        [id]
    );
    return rows[0];
};

// 4. Borrado lógico
const borrarPatologia = async (id) => {
    const [resultado] = await pool.query(
        `UPDATE tbc_patologias SET Estatus_Patologia = 0 WHERE ID_Patologia = ?`,
        [id]
    );
    return resultado;
};

// 5. Actualizar
const actualizarPatologia = async (id, data) => {
    const { nombre, nombre_cientifico, nombre_comun, descripcion } = data;
    const [resultado] = await pool.query(
        `UPDATE tbc_patologias 
         SET Nombre = ?, Nombre_Cientifico = ?, Nombre_Comun = ?, Descripcion = ? 
         WHERE ID_Patologia = ?`,
        [nombre, nombre_cientifico, nombre_comun, descripcion, id]
    );
    return resultado;
};

module.exports = {
    findAll,
    findById,
    crearPatologia,
    borrarPatologia,
    actualizarPatologia
};