const pool = require('../config/database');

const obtenerReporteRoles = async () => {
    // Usamos una de las vistas que mostraste en tu lista (vw_roles_usuarios)
    const [rows] = await pool.query("SELECT * FROM vw_roles_usuarioss");
    return rows;
};

module.exports = { obtenerReporteRoles };