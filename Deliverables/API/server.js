const app = require('./src/app');
const connectMongoDB = require('./src/config/mongodb');
const pool = require('./src/config/database');
require('dotenv').config();

const PORT = process.env.PORT || 3000;

const startServer = async () => {
    try {
        // 1. Conectar a MongoDB usando la función del módulo
        await connectMongoDB();

        // 2. Probar conexión a MySQL
        await pool.query('SELECT 1'); 
        console.log('✅ 2/2 Conexión a MySQL Exitosa');

        // 3. Arrancar el servidor solo si ambos funcionan
        const server = app.listen(PORT, () => {
            console.log('--------------------------------------------------');
            console.log(`🚀 SERVIDOR HÍBRIDO CORRIENDO EN PUERTO ${PORT}`);
            console.log(`🔗 Documentación: http://localhost:${PORT}/api-docs`);
            console.log('--------------------------------------------------');
        });

        // Manejo de errores después de que el servidor está escuchando
        server.on('error', (err) => {
            console.error('❌ Error en el servidor:', err);
        });

    } catch (err) {
        console.error('❌ ERROR CRÍTICO AL INICIAR EL SISTEMA:');
        console.error(err.message);
        process.exit(1);
    }
};

startServer();