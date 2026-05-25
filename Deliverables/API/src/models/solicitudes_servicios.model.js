const mongoose = require('mongoose');

/*
Participantes asociados a la solicitud.
Representa personas involucradas en el servicio.
*/
const ParticipanteSchema = new mongoose.Schema({

  persona_id: {
    type: Number,
    required: true
    // FK lógica → MySQL: tbb_hr_personas.ID
  },

  nombre: {
    type: String,
    required: true
    // Snapshot del nombre de la persona
  },

  rol_participacion: {
    type: String,
    enum: ["Solicitante","Beneficiario","Asignado","Observador"],
    default: "Beneficiario"
  },

  fecha_registro: {
    type: Date,
    default: Date.now
  }

},{ _id:false });


/*
Historial de cambios de estatus de la solicitud.
*/
const HistorialEstatusSchema = new mongoose.Schema({

  estatus: {
    type: String,
    required: true
  },

  fecha: {
    type: Date,
    default: Date.now
  },

  usuario_id: {
    type: Number,
    // FK lógica → MySQL: personal del sistema
  },

  usuario_nombre: String,

  comentario: String

},{ _id:false });


/*
Snapshot de costo aplicado a la solicitud.
No representa facturación completa, sólo el costo
al momento de generar la solicitud.
*/
const CostoSchema = new mongoose.Schema({

  aplica: {
    type: Boolean,
    default: false
    // Debe corresponder al campo:
    // MySQL → tbc_ge_servicios.Costo
  },

  monto_unitario: {
    type: Number,
    default: 0
    // Precio unitario del servicio
  },

  cantidad: {
    type: Number,
    default: 1
  },

  descuento: {
    type: Number,
    default: 0
  },

  total: {
    type: Number,
    default: 0
    // (monto_unitario * cantidad) - descuento
  }

},{ _id:false });


const SolicitudServicioSchema = new mongoose.Schema({

  folio: {
    type: String,
    required: true,
    unique: true
  },

  servicio: {

    id: {
      type: Number,
      required: true
      // FK → MySQL: tbc_ge_servicios.ID
    },

    nombre: {
      type: String,
      required: true
      // Snapshot del nombre
    }

  },

  solicitante: {

    id: {
      type: Number,
      required: true
      // FK → MySQL: tbb_hr_personas.ID
    },

    nombre: {
      type: String,
      required: true
    }

  },

  area: {

    id: {
      type: Number,
      required: true
      // FK → MySQL: tbc_ge_areas.ID
    },

    nombre: {
      type: String,
      required: true
    }

  },

  descripcion: String,

  costo: {
    type: CostoSchema,
    default: () => ({})
  },

  estatus: {
    type: String,
    enum: ["pendiente","en_proceso","completado","cancelado"],
    default: "pendiente"
  },

  prioridad: {
    type: String,
    enum: ["baja","media","alta","urgente"],
    default: "media"
  },

  fechas: {

    solicitud: {
      type: Date,
      default: Date.now
    },

    actualizacion: Date,

    cierre: Date

  },

  canal_origen: {
    type: String,
    enum: ["web","telefono","app","interno","presencial"]
  },

  observaciones: String,

  participantes: [ParticipanteSchema],

  historial_estatus: [HistorialEstatusSchema]

},{
  collection: "solicitudes_servicios",
  timestamps: true
});


/* Índices */

SolicitudServicioSchema.index({ prioridad: 1 });
SolicitudServicioSchema.index({ "servicio.id": 1 });
SolicitudServicioSchema.index({ "solicitante.id": 1 });
SolicitudServicioSchema.index({ "area.id": 1 });
SolicitudServicioSchema.index({ "fechas.solicitud": -1 });

module.exports = mongoose.model("SolicitudServicio", SolicitudServicioSchema);