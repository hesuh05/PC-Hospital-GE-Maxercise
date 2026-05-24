import mongoose from "mongoose";

const AprobacionSchema = new mongoose.Schema({

  entidad: {

    tipo: {
      type: String,
      required: true,
      enum: [
        "SolicitudServicio",
        "Cirugia",
        "Traslado",
        "Campania",
        "Otro"
      ]
    },

    id: {
      type: Number,
      required: true
      // ID de la entidad aprobada
    },

    folio: String

  },

  solicitante: {

    id: {
      type: Number,
      required: true
      // FK → MySQL: tbb_hr_personas.ID
    },

    nombre: String

  },

  aprobador: {

    id: {
      type: Number,
      required: true
      // Personal que aprueba
    },

    nombre: String

  },

  nivel: {
    type: Number,
    default: 1
    // Nivel jerárquico de aprobación
  },

  estatus: {
    type: String,
    enum: ["pendiente","aprobado","rechazado","cancelado"],
    default: "pendiente"
  },

  comentario: String,

  fecha_solicitud: {
    type: Date,
    default: Date.now
  },

  fecha_respuesta: Date

},{
  collection: "aprobaciones"
});


/* Índices */

AprobacionSchema.index({ "entidad.tipo": 1, "entidad.id": 1 });
AprobacionSchema.index({ "aprobador.id": 1 });
AprobacionSchema.index({ "solicitante.id": 1 });
AprobacionSchema.index({ estatus: 1 });
AprobacionSchema.index({ "entidad.tipo": 1, "entidad.id": 1, estatus: 1 });

export default mongoose.model("Aprobacion", AprobacionSchema);