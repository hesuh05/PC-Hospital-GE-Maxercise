# Requisitos de Usuario (URs) - Área de Gerencia
**Hospital de Tercer Nivel (Alta Especialidad)**

Este documento consolida las necesidades de alto nivel que tienen los usuarios (administradores, médicos especialistas, directivos del hospital y coordinadores de calidad) para interactuar de forma eficiente con el sistema del área de **Gerencia**.

---

## 1. Requisitos de Gestión Operativa Hospitalaria

### **UR-GE-401: Control de la Capacidad e Infraestructura de Áreas**
- **Descripción:** La Dirección de Operaciones requiere supervisar en tiempo real el estado funcional de las áreas (climatización, abasto de insumos, camas disponibles) para activar planes de contingencia (ej. reconversión de camas de terapia intermedia a cuidados intensivos pulmonares).
- **Necesidad del Usuario:** Ver el estado operativo de cada sala (Activa, Inactiva, Suspendida, Cancelada), el número actual de personal asignado y las subáreas que dependen de ella para coordinar cierres preventivos de mantenimiento sin interrumpir servicios críticos.

### **UR-GE-402: Trazabilidad Epidemiológica de Enfermedades**
- **Descripción:** El comité médico requiere una herramienta para catalogar las enfermedades registradas en los pacientes y cruzarlas con clasificaciones oficiales nacionales e internacionales (CIE-10 / CIE-11).
- **Necesidad del Usuario:** Registrar una patología asignándole múltiples clasificaciones epidemiológicas (ej. patología cardiovascular + metabólica) y consultar rápidamente la incidencia de casos asociados por clasificación para detectar brotes intrahospitalarios.

---

## 2. Requisitos de Coordinación Médica de Trasplantes

### **UR-GE-403: Alertas y Control Crítico de Órganos Donados**
- **Descripción:** El equipo de trasplantes necesita un monitoreo estricto de los órganos extraídos en stock, ya que cada minuto fuera del cuerpo (tiempo de isquemia fría) reduce la probabilidad de éxito en el receptor.
- **Necesidad del Usuario:** Visualizar los órganos disponibles ordenados por menor tiempo de viabilidad restante (alertas de expiración), y filtrar de inmediato por grupo sanguíneo y características del donante para empatar de forma óptima con la lista de espera de receptores compatibles.

---

## 3. Requisitos de Control de Calidad y Servicio al Paciente

### **UR-GE-404: Buzón Unificado de Reclamos y Sugerencias**
- **Descripción:** El departamento de Calidad y Atención al Paciente requiere centralizar todos los canales por los que los usuarios expresan quejas o ideas de mejora (buzón físico, app, web, vía telefónica).
- **Necesidad del Usuario:** Registrar y consultar quejas o sugerencias asignando prioridades, vinculando el folio de la queja directamente al departamento de ocurrencia y al personal implicado. Asimismo, se requiere registrar notas históricas de conciliación y llamadas de seguimiento en una bitácora digital de libre formato.

---

## 4. Requisitos Financieros y Administrativos

### **UR-GE-405: Autorización de Solicitudes Especiales de Alto Costo**
- **Descripción:** El área de Finanzas y Dirección de Administración requiere aprobar de forma explícita toda solicitud de servicio no convencional o de alto costo (ej. cirugías experimentales, trasplantes, traslados en helicóptero, campañas de salud extraordinarias) para controlar el presupuesto del hospital.
- **Necesidad del Usuario:** Un panel digital donde las solicitudes entrantes muestren un desglose del costo al momento de registrarse y la prioridad. El directivo debe poder autorizar de forma remota y justificar mediante comentarios el rechazo o aprobación antes de que los insumos clínicos sean liberados por almacén.

---

## 5. Requisitos de Auditoría y Control de Calidad Interno

### **UR-GE-406: Registro Inalterable de Operaciones de Catálogo**
- **Descripción:** Auditoría Interna del hospital requiere que cualquier modificación en las tablas maestras (Áreas, Órganos, Patologías, Servicios) sea registrada para evitar fraudes en facturaciones o asignaciones de quirófanos y órganos.
- **Necesidad del Usuario:** Acceder a un log o bitácora de auditoría histórica inalterable que indique qué usuario de base de datos modificó o dio de alta un registro, qué datos se cambiaron y la fecha exacta del suceso.
