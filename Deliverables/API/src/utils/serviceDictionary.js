const diccionariosServicios = {
  "Servicios Medicos": {
    descripciones: [
      "Paciente con dolor agudo en abdomen, requiere valoración urgente.",
      "Solicitud de consulta general por síntomas de resfriado severo.",
      "Revisión post-operatoria de cirugía cardiovascular.",
      "Paciente diabético requiere sesión de hemodiálisis programada.",
      "Solicitud de estudio de resonancia magnética por trauma craneal."
    ],
    observaciones: [
      "Paciente presenta alta sensibilidad al dolor, tratar con cuidado.",
      "Requiere silla de ruedas para traslado.",
      "Paciente alérgico a la penicilina.",
      "Viene acompañado de un familiar de la tercera edad."
    ],
    historial: {
      en_proceso: ["Paciente en sala de espera.", "Pasó a triage para toma de signos vitales.", "El médico especialista está revisando el caso."],
      completado: ["Consulta finalizada, se emite receta.", "Procedimiento realizado sin complicaciones.", "Paciente estabilizado y dado de alta."],
      cancelado: ["El paciente abandonó la sala de espera.", "Se cancela por falta de ayuno para el estudio."]
    },
    aprobaciones: {
      aprobado: ["Se autoriza procedimiento médico con base en el diagnóstico.", "Pase a especialista aprobado por urgencia clínica."],
      rechazado: ["Se rechaza intervención, el paciente no cumple los criterios de riesgo.", "Faltan estudios previos para autorizar la cirugía."]
    }
  },
  "Farmacia": {
    descripciones: [
      "Surtimiento de receta médica folio 4509.",
      "Solicitud de medicamento controlado (Psicotrópico).",
      "Requisición de material de curación para piso 3.",
      "Solicitud de insulina glargina para tratamiento mensual."
    ],
    observaciones: [
      "Verificar vigencia de la receta antes de surtir.",
      "Medicamento requiere red de frío inmediata.",
      "Entregar solo al titular con identificación oficial."
    ],
    historial: {
      en_proceso: ["Verificando existencias en el inventario central.", "Preparando el paquete de medicamentos."],
      completado: ["Medicamentos entregados correctamente al paciente.", "Surtimiento completo, inventario actualizado."],
      cancelado: ["Receta caducada, no procede surtimiento.", "Medicamento agotado, se pide regresar mañana."]
    },
    aprobaciones: {
      aprobado: ["Se autoriza la liberación del medicamento controlado.", "Inventario validado, procede el surtimiento."],
      rechazado: ["Firma del médico tratante no coincide o no está autorizada.", "No se aprueba surtimiento múltiple para el mismo mes."]
    }
  },
  "Registros Medicos": {
    descripciones: [
      "Solicitud de copias certificadas de expediente clínico.",
      "Actualización de datos personales en el sistema general.",
      "Solicitud de resumen clínico para aseguradora externa.",
      "Petición de historial de vacunación pediátrica."
    ],
    observaciones: [
      "El trámite requiere pago previo en caja.",
      "El paciente urge las copias para trámite legal.",
      "Cobro exonerado por Trabajo Social."
    ],
    historial: {
      en_proceso: ["Buscando expediente físico en bodega inactiva.", "Digitalizando documentos solicitados."],
      completado: ["Copias entregadas y firmadas de recibido.", "Resumen clínico enviado a la aseguradora."],
      cancelado: ["Paciente no trajo identificación oficial, trámite detenido.", "No se encontró pago referenciado."]
    },
    aprobaciones: {
      aprobado: ["Se aprueba la emisión de copias por parte del titular.", "Liberación de datos autorizada por el comité de privacidad."],
      rechazado: ["Se niega acceso, el solicitante no es el titular ni apoderado legal."]
    }
  },
  "General": { // Fallback para áreas sin diccionario específico
    descripciones: ["Solicitud de servicio interno.", "Requerimiento de apoyo administrativo.", "Mantenimiento preventivo de área."],
    observaciones: ["Dar prioridad si es posible.", "Atender en horario laboral."],
    historial: {
      en_proceso: ["Se ha asignado a un responsable.", "Revisando requerimientos técnicos."],
      completado: ["Servicio finalizado exitosamente.", "Se cumplió con el requerimiento."],
      cancelado: ["Cancelado por falta de presupuesto.", "El usuario retiró la solicitud."]
    },
    aprobaciones: {
      aprobado: ["Aprobado por jefatura.", "Visto bueno administrativo."],
      rechazado: ["Rechazado temporalmente, falta justificación.", "No cumple con las normativas actuales."]
    }
  }
};

module.exports = { diccionariosServicios };