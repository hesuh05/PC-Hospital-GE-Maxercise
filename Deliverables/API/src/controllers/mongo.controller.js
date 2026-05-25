const QuejaSugerencia = require('../models/QuejaSugerencia');
const Aprobacion = require('../models/Aprobacion.js');
const SolicitudServicio = require('../models/SolicitudServicio.js');

// Función genérica para guardar lo que mandes desde Swagger
const insertarEnMongo = async (req, res) => {
    try {
        const { coleccion } = req.params; // Sabemos a qué tabla va
        let nuevoDocumento;

        if (coleccion === 'quejas') nuevoDocumento = new QuejaSugerencia(req.body);
        if (coleccion === 'aprobaciones') nuevoDocumento = new Aprobacion(req.body);
        if (coleccion === 'servicios') nuevoDocumento = new SolicitudServicio(req.body);

        await nuevoDocumento.save(); // ¡Aquí es donde se guarda de verdad!
        res.status(201).json({ mensaje: "Guardado en MongoDB", data: nuevoDocumento });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { insertarEnMongo };