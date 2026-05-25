const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const swaggerUI = require('swagger-ui-express');
const swaggerDocument = require('../swagger.json'); 

const app = express();

// --- SECCIÓN DE SEGURIDAD (CORS Y HELMET) ---
app.use(helmet({
    contentSecurityPolicy: false,
    crossOriginOpenerPolicy: false,
    crossOriginEmbedderPolicy: false,
    hsts: false
}));
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE']
}));

// Limitador de peticiones
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 200,
    message: "Demasiadas peticiones, intente más tarde."
});
app.use('/gerencia', limiter); 

app.use(express.json());

// --- CONFIGURACIÓN DE SWAGGER ---
app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerDocument));

app.get('/', (req, res) => {
  res.json({ message: 'API Gerencia Hospital funcionando con Seguridad y CORS' });
});

// --- IMPORTACIÓN DE RUTAS ---
const gerenciaRoutes = require('./routes/gerencia.routes');
const organosRoutes = require('./routes/gerencia.organos.routes');
const organosInventarioRoutes = require('./routes/organosInventario.routes');
const areasroutes = require('./routes/areas.routes');
const aprobacionesroutes = require('./routes/aprobaciones.routes');
const accesosRoutes = require('./routes/accesos.routes');
const patologiaTiposRoutes = require('./routes/patologia.tipos.routes');
const vistasRoutes = require('./routes/vistas.routes');
const poblarPacientesRoutes = require('./routes/poblarpacientes.routes');
const mongoRoutes = require('./routes/mongo.routes');
const poblarQuejasSugerenciasRoutes = require('./routes/poblarQuejasSugerencias.routes')
const solicitudesRoutes = require('./routes/solicitudes.routes');

// --- CONEXIÓN DE RUTAS ---
app.use('/gerencia', poblarPacientesRoutes);
app.use('/gerencia', vistasRoutes);
app.use('/gerencia', patologiaTiposRoutes);
app.use('/gerencia', accesosRoutes);
app.use('/gerencia', aprobacionesroutes);
app.use('/gerencia', organosInventarioRoutes);
app.use('/gerencia', organosRoutes);
app.use('/gerencia', gerenciaRoutes);
app.use('/gerencia', areasroutes);
app.use('/gerencia', mongoRoutes);
app.use('/gerencia', poblarQuejasSugerenciasRoutes)
app.use('/gerencia', solicitudesRoutes);

module.exports = app;