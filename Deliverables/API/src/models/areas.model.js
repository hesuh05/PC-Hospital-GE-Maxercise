const pool = require('../config/database');

// 1. Obtener todas las áreas activas
const findAll = async () => {
    const [rows] = await pool.query(
        `SELECT 
            ID, Nombre, Descripcion, Estatus_Operacion, Total_Empleados 
         FROM tbc_areas 
         WHERE Estatus = 1`
    );
    return rows;
};

// 2. Crear área (Con Estatus = 1 por defecto para que no se pierdan)
const create = async (data) => {
    // Definimos valores por defecto para evitar los NULLs que ocultan datos
    const { 
        nombre, 
        descripcion, 
        ubicacion_id = null, 
        personal_id_responsable = null, 
        area_superior_id = null, 
        estatus_operacion = 'Activo', 
        total_empleados = 0 
    } = data;

    const [result] = await pool.query(
        `INSERT INTO tbc_areas 
        (Nombre, Descripcion, Ubicacion_ID, Personal_ID_Responsable, Area_Superior_ID, Estatus_Operacion, Total_Empleados, Fecha_Registro, Estatus) 
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), 1)`, 
        // Agregamos el "1" al final para activar el bit de Estatus automáticamente
        [
            nombre, 
            descripcion, 
            ubicacion_id, 
            personal_id_responsable, 
            area_superior_id, 
            estatus_operacion, 
            total_empleados
        ]
    );
    return result;
};

// 3. Actualización de Estatus Operativo (Mantenimiento, Activo, etc.)
const updateArea = async (id, data) => {
    const { nombre, descripcion, estatus_operacion, total_empleados } = data;
    
    const [result] = await pool.query(
        `UPDATE tbc_areas 
         SET Nombre = COALESCE(?, Nombre), 
             Descripcion = COALESCE(?, Descripcion), 
             Estatus_Operacion = COALESCE(?, Estatus_Operacion), 
             Total_Empleados = COALESCE(?, Total_Empleados), 
             Fecha_Actualizacion = NOW() 
         WHERE ID = ?`,
        [nombre || null, descripcion || null, estatus_operacion || null, total_empleados || null, id]
    );
    return result;
};
// 4. Soft Delete (Desactivación lógica)
const softDelete = async (id) => {
    const [result] = await pool.query(
        `UPDATE tbc_areas SET Estatus = 0 WHERE ID = ?`,
        [id]
    );
    return result;
};

module.exports = {
    findAll,
    create,
    updateArea,
    softDelete
};