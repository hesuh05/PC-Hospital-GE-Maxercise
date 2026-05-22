# Reglas de Negocio (BRs) - Área de Gerencia
**Hospital de Tercer Nivel (Alta Especialidad)**

Este documento define las políticas, restricciones y reglas operativas independientes de la tecnología que rigen los procesos del área de **Gerencia** en el hospital de tercer nivel. Estas reglas aseguran la integridad de los datos, el cumplimiento de regulaciones médicas de alta especialidad y la trazabilidad administrativa.

---

## 1. Estructura de Áreas Hospitalarias

### **BR-GE-001: Jerarquía Organizativa sin Ciclos**
- **Descripción:** Un área hospitalaria (`tbc_ge_areas`) puede estar subordinada a otra área superior (ej. *Unidad de Cuidados Intensivos Coronarios* subordinada a *Cardiología*). No se permiten dependencias cíclicas; un área no puede ser superior de sí misma ni de ninguna de sus subáreas.
- **Impacto:** Integridad estructural del organigrama.

### **BR-GE-002: Inactivación y Propagación Operativa**
- **Descripción:** Si el estado operativo de un área cambia a `Suspendida` o `Inactiva`, todas las solicitudes de servicios vinculadas que estén en estado `pendiente` deben ser pausadas o reasignadas automáticamente. Las áreas inactivadas físicamente (`Estatus = 0`) no deben recibir nuevas solicitudes de servicio.
- **Impacto:** Continuidad operativa y seguridad en la atención.

---

## 2. Inventario de Órganos y Trasplantes (Alta Especialidad)

### **BR-GE-003: Tiempo de Viabilidad Isquémica (Fecha de Expiración)**
- **Descripción:** Todo órgano registrado en el inventario (`tbb_ge_organos_inventario`) debe tener obligatoriamente una fecha y hora límite de expiración calculada a partir del momento de la extracción del donante. Este límite sigue el protocolo médico internacional de preservación fría:
  - **Corazón:** Máximo 4 a 6 horas.
  - **Pulmón:** Máximo 6 a 8 horas.
  - **Hígado:** Máximo 12 horas.
  - **Riñón:** Máximo 24 a 36 horas.
  - **Córnea:** Máximo 7 a 14 días (en medio de preservación).
- **Impacto:** Calidad del injerto y viabilidad del trasplante.

### **BR-GE-004: Compatibilidad Inmunológica de Grupo Sanguíneo**
- **Descripción:** Ningún órgano puede ser asignado o retirado del inventario para un receptor si no existe una coincidencia de compatibilidad de grupo sanguíneo (sistema ABO y factor Rh) de acuerdo con las reglas de inmunología transfusional:
  - Órgano tipo **O** puede ser donado a receptores A, B, AB, O (Donante Universal).
  - Órgano tipo **A** puede ser donado a receptores A y AB.
  - Órgano tipo **B** puede ser donado a receptores B y AB.
  - Órgano tipo **AB** solo puede ser donado a receptores AB (Receptor Universal).
- **Impacto:** Prevención del rechazo hiperagudo de injertos.

---

## 3. Clasificación Epidemiológica de Patologías

### **BR-GE-005: Clasificación Multidimensional**
- **Descripción:** Una patología catalogada en el hospital (`tbc_ge_patologias`) puede pertenecer a múltiples categorías o clasificaciones médicas simultáneamente (ej. la *Neumonía por COVID-19* se clasifica como "Infecciosa" y "Respiratoria" a la vez) a través de una relación de muchos a muchos (`tbd_ge_patologias_tipos`).
- **Impacto:** Reportes epidemiológicos y control de brotes en un hospital de tercer nivel.

---

## 4. Gestión de Quejas y Sugerencias (Control de Calidad)

### **BR-GE-006: Estado Inicial por Defecto**
- **Descripción:** Al registrarse una queja o sugerencia de forma manual o digital en el buzón gerencial, si el estado del trámite es nulo:
  - Si es de tipo **Queja**, el sistema le asigna por defecto el estatus `registrada`.
  - Si es de tipo **Sugerencia**, se le asigna el estatus `recibida`.
- **Impacto:** Estandarización del flujo de atención al usuario.

### **BR-GE-007: Trazabilidad del Historial de Seguimiento**
- **Descripción:** Cada vez que una queja o sugerencia cambia de estatus (registrada $\rightarrow$ en revisión $\rightarrow$ en proceso $\rightarrow$ atendida $\rightarrow$ cerrada $\rightarrow$ cancelada), se debe generar obligatoriamente una entrada en el historial de seguimiento (`seguimiento`), capturando:
  - La fecha y hora exacta del cambio.
  - La descripción de la acción.
  - El identificador y nombre del personal gerencial responsable de la acción.
  - El comentario justificativo.
- **Impacto:** Auditoría interna de calidad en el servicio.

---

## 5. Autorizaciones y Aprobaciones Gerenciales

### **BR-GE-008: Aprobación Jerárquica de Procesos Complejos**
- **Descripción:** Toda solicitud que involucre cirugías mayores, campañas de salud comunitaria, traslados de pacientes críticos o servicios de alto costo requiere una aprobación formal registrada en el sistema (`tbd_ge_aprobaciones`). El estatus final de aprobación determina si la orden clínica se libera para su ejecución.
- **Impacto:** Control de costos y uso óptimo de recursos especializados.

---

## 6. Auditoría y Conservación de Datos (Cumplimiento Regulatorio)

### **BR-GE-009: Bitácora Obligatoria Automatizada**
- **Descripción:** Cualquier operación de inserción (INSERT), modificación (UPDATE) o eliminación (DELETE) en las tablas de catálogos y transacciones de SQL de Gerencia debe registrar en tiempo real y sin intervención humana en la bitácora (`tbi_bitacora`):
  - El nombre de la tabla afectada.
  - El usuario del motor de base de datos que realizó el cambio.
  - El tipo de operación.
  - Una descripción detallada de los registros antiguos y nuevos (o ID afectado).
  - La fecha y hora exacta de la transacción.
- **Impacto:** Transparencia administrativa y prevención de fraudes.

### **BR-GE-010: Conservación por Desactivación Lógica (Soft Delete)**
- **Descripción:** Queda prohibida la eliminación física de registros históricos en las tablas de catálogos gerenciales. Cualquier solicitud de baja debe realizarse mediante borrado lógico, cambiando el campo `Estatus` o `Estatus_Patologia` a `0`. Los registros con estatus inactivo se omiten de la operación cotidiana pero se conservan para auditoría clínica e histórica.
- **Impacto:** Preservación de históricos epidemiológicos y administrativos.
