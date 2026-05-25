const pool = require('../config/database');

const organosModel = require('../models/organos.model');
const areasModel = require('../models/areas.model');
const organosInventarioModel = require('../models/organosInventario.model');
const patologiasModel = require('../models/patologias.model');
const patologiaTiposModel = require('../models/patologia.tipos.model');
const accesosModel = require('../models/accesos.model');
const aprobacionesModel = require('../models/aprobaciones.model');

// 1. Función para POBLAR (Corregida a 11 parámetros)
const poblarPacientesProcedimiento = async (req, res) => {
    // Helper para leer p_ y nombre amigable, manteniendo null explícito
    const param = (primary, alt, defaultValue) => {
        if (Object.prototype.hasOwnProperty.call(req.body, primary)) return req.body[primary];
        if (Object.prototype.hasOwnProperty.call(req.body, alt)) return req.body[alt];
        return defaultValue;
    };

    const p_cantidad = param('p_cantidad', null, 10);
    const p_c_genero = param('p_c_genero', null, 'H');
    const p_edad_minima = param('p_edad_minima', null, 18);
    const p_edad_maxima = param('p_edad_maxima', null, 99);
    const p_estatus_vida = param('p_estatus_vida', null, 'Vivo');
    const p_modo_estatus_medico = param('p_modo_estatus_medico', null, -1);
    const p_estatus_medico = param('p_estatus_medico', null, 'Estable');
    const p_tipo_edad = param('p_tipo_edad', null, 'adulto');
    const p_modo_situacion_medica = param('p_modo_situacion_medica', null, -1);
    const p_situacion_medica = param('p_situacion_medica', null, null);
    const p_modo_titulo = param('p_modo_titulo', null, null);

    // const { 
    //     cantidad, genero, edad_min, edad_max, estatus_vida, 
    //     sangre_id, estatus_medico, unidad_edad, param_extra,
    //     usuario_id, sucursal_id 
    // } = req.body; 

    try {
        // AHORA MANDAMOS 11 PARÁMETROS (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        const [result] = await pool.query(
            'CALL sp_poblar_pacientes(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
            [
                p_cantidad,
                p_c_genero,
                p_edad_minima,
                p_edad_maxima,
                p_estatus_vida,
                p_modo_estatus_medico,
                p_estatus_medico,
                p_tipo_edad,
                p_modo_situacion_medica,
                p_situacion_medica,
                p_modo_titulo
            ]
        );
        res.status(200).json({
            success: true,
            message: "Procedimiento ejecutado con éxito",
            ip: req.ip.split("::ffff:")[1],
            resultado: result
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error al llamar al procedimiento almacenado",
            error: error.message
        });
    }
};

// 2. Función para LIMPIAR la tabla
const limpiarPacientes = async (req, res) => {
    try {
        await pool.query('TRUNCATE TABLE tbb_md_pacientes');
        res.status(200).json({
            success: true,
            message: "Tabla tbb_md_pacientes vaciada correctamente"
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error al vaciar la tabla",
            error: error.message
        });
    }
};

// 3. Función para CONSULTAR
const obtenerPacientes = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM tbb_md_pacientes ORDER BY id DESC LIMIT 100');
        res.status(200).json({
            success: true,
            data: rows
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Error al obtener los pacientes",
            error: error.message
        });
    }
};

// 4. Estructura base para poblar otras tablas (mantener el flujo existente y el comportamiento actual)
const poblarOrganos = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            await organosModel.create({
                Nombre: `Organo Auto ${Date.now()}-${i}`,
                Sistema_Aparato: 'Sistema de Prueba',
                Requisitos: 'Requisitos de ejemplo',
                Stock: 10,
                Descripcion: 'Descripción generada automáticamente',
                Funcion: 'Función estándar',
                Fecha_Registro: new Date().toISOString().slice(0, 10)
            });
            insertados++;
        }

        res.status(201).json({
            success: true,
            message: `${insertados} órganos creados`,
            created: insertados
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Error al poblar órganos',
            error: error.message
        });
    }
};

const poblarAreas = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            await areasModel.create({
                nombre: `Área Auto ${Date.now()}-${i}`,
                descripcion: 'Área generada para pruebas',
                ubicacion_id: null,
                personal_id_responsable: null,
                area_superior_id: null,
                estatus_operacion: 'Activo',
                total_empleados: 5
            });
            insertados++;
        }

        res.status(201).json({
            success: true,
            message: `${insertados} áreas creadas`,
            created: insertados
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Error al poblar áreas',
            error: error.message
        });
    }
};

const poblarInventario = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        const organos = await organosModel.findAll();
        if (!organos || organos.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'No hay órganos disponibles. Cree órganos primero.'
            });
        }

        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            const organoId = organos[(i - 1) % organos.length].ID_Organo;
            await organosInventarioModel.create({
                Organo_ID: organoId,
                Fecha_Expiracion: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10),
                Estado: 'Disponible',
                Raza: 'N/A',
                Grupo_Sanguineo: 'O+',
                Observaciones: `Lote auto ${i}`
            });
            insertados++;
        }

        res.status(201).json({
            success: true,
            message: `${insertados} inventarios creados`,
            created: insertados
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Error al poblar inventario de órganos',
            error: error.message
        });
    }
};

const poblarTiposPatologia = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            await patologiaTiposModel.createTipo({
                nombre: `TipoPatologia Auto ${Date.now()}-${i}`,
                descripcion: 'Tipo generado automáticamente'
            });
            insertados++;
        }
        res.status(201).json({ success: true, message: `${insertados} tipos de patología creados`, created: insertados });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error al poblar tipos de patología', error: error.message });
    }
};

const poblarPatologias = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        // Nota: require de tipos para asignar, si no hay tipos se crea a mano
        const tipos = await patologiaTiposModel.getTipos();
        let tiposIds = tipos && tipos.length ? [tipos[0].ID_Tipo_Patologia] : [];

        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            await patologiasModel.crearPatologia({
                nombre: `Patología Auto ${Date.now()}-${i}`,
                nombre_cientifico: `Scientia ${i}`,
                nombre_comun: `Común ${i}`,
                descripcion: 'Patología de prueba',
                fecha_clasificacion: new Date().toISOString().slice(0, 10),
                tipos_ids: tiposIds
            });
            insertados++;
        }

        res.status(201).json({ success: true, message: `${insertados} patologías creadas`, created: insertados });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error al poblar patologías', error: error.message });
    }
};

const poblarAccesos = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            await accesosModel.create({
                persona_id: i,
                espacio_id: 1,
                tipo: i % 2 === 0 ? 'Entrada' : 'Salida',
                autoriza_id: 1
            });
            insertados++;
        }
        res.status(201).json({ success: true, message: `${insertados} accesos creados`, created: insertados });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error al poblar accesos', error: error.message });
    }
};

const poblarAprobaciones = async (req, res) => {
    const cantidad = Number(req.body.cantidad || 5);
    try {
        let insertados = 0;
        for (let i = 1; i <= cantidad; i++) {
            await aprobacionesModel.create({
                personal_id: i,
                servicio_id: i,
                servicio_descripcion: `Servicio Auto ${i}`
            });
            insertados++;
        }
        res.status(201).json({ success: true, message: `${insertados} aprobaciones creadas`, created: insertados });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error al poblar aprobaciones', error: error.message });
    }
};

const poblarTodo = async (req, res) => {
    try {
        await poblarPacientesProcedimiento(req, res); // mantiene el flujo pacientes
        // para no duplicar vistas al cliente, poebl todo en respuestas separadas
        await poblarOrganos(req, res);
        await poblarAreas(req, res);
        await poblarInventario(req, res);
        await poblarTiposPatologia(req, res);
        await poblarPatologias(req, res);
        await poblarAccesos(req, res);
        await poblarAprobaciones(req, res);

        res.status(201).json({ success: true, message: 'Poblaciones de tablas ejecutadas (pacientes + resto)' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error al poblar todas las tablas', error: error.message });
    }
};

module.exports = {
    poblarPacientesProcedimiento,
    limpiarPacientes,
    obtenerPacientes,
    poblarOrganos,
    poblarAreas,
    poblarInventario,
    poblarTiposPatologia,
    poblarPatologias,
    poblarAccesos,
    poblarAprobaciones,
    poblarTodo
};