import mongoose from "mongoose";

/*
Registro de seguimiento de la queja o sugerencia.
*/
const SeguimientoSchema = new mongoose.Schema({

  fecha: {
    type: Date,
    default: Date.now
  },

  accion: String,

  usuario_id: {
    type: Number
    // FK lógica → Personal del sistema
  },

  usuario_nombre: String,

  comentario: String

},{ _id:false });


const QuejaSugerenciaSchema = new mongoose.Schema({

  folio: {
    type: String,
    required: true,
    unique: true
  },

  tipo: {
    type: String,
    enum: ["queja","sugerencia"],
    required: true
  },

  categoria: String,

  prioridad: {
    type: String,
    enum: ["baja","media","alta","urgente"],
    default: "media"
  },

  descripcion: {
    type: String,
    required: true
  },

  persona_fisica: {

    id: {
      type: Number,
      required: true
      // FK → MySQL: tbb_hr_personas.ID
    },

    nombre: String

  },

  departamento: {

    id: {
      type: Number,
      required: true
      // FK → MySQL: tbc_ge_areas.ID
    },

    nombre: String

  },

  medio_recepcion: {
    type: String,
    enum: ["buzon","web","telefono","presencial","app"]
  },

  estatus: {
    type: String,
    enum: [
      "registrada",
      "en_revision",
      "en_proceso",
      "atendida",
      "cerrada",
      "cancelada"
    ],
    default: "registrada"
  },

  responsable: {

    id: Number,
    nombre: String
    // Personal que atiende la queja
  },

  respuesta: String,

  fechas: {

    registro: {
      type: Date,
      default: Date.now
    },

    atencion: Date,

    cierre: Date

  },

  seguimiento: [SeguimientoSchema]

},{
  collection: "quejas_sugerencias"
});


/* Índices */

QuejaSugerenciaSchema.index({ folio: 1 }, { unique: true });
QuejaSugerenciaSchema.index({ tipo: 1 });
QuejaSugerenciaSchema.index({ categoria: 1 });
QuejaSugerenciaSchema.index({ prioridad: 1 });
QuejaSugerenciaSchema.index({ estatus: 1 });
QuejaSugerenciaSchema.index({ "persona_fisica.id": 1 });
QuejaSugerenciaSchema.index({ "departamento.id": 1 });
QuejaSugerenciaSchema.index({ "fechas.registro": -1 });

export default mongoose.model("QuejaSugerencia", QuejaSugerenciaSchema);