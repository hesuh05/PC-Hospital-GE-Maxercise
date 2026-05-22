# Historias de Usuario (UHs) - Área de Gerencia
**Hospital de Tercer Nivel (Alta Especialidad)**

Este documento recopila las historias de usuario que describen las necesidades operativas y administrativas del personal y directivos del hospital, estructuradas con sus respectivos criterios de aceptación.

---

## 1. Módulo de Gestión de Áreas Hospitalarias

### **UH-GE-301: Estructura Jerárquica de Áreas**
- **Como** Director de Operaciones Hospitalarias,
- **quiero** registrar y clasificar las áreas del hospital asociándolas con un área superior,
- **para** mantener actualizado el organigrama espacial y departamental de la institución.
- **Criterios de Aceptación:**
  1. Al registrar un área, el sistema debe permitir seleccionar opcionalmente un área superior existente.
  2. El sistema debe impedir dependencias cíclicas (ej. que el área "Quirófano A" sea superior de "Cardiología" y a su vez "Cardiología" sea superior de "Quirófano A").
  3. Al consultar las áreas activas (`Estatus = 1`), debe mostrarse de manera clara el nombre del área superior, su estado operativo y el número actual de empleados.

---

## 2. Módulo de Trasplantes e Inventario de Órganos

### **UH-GE-302: Registro de Compatibilidad Inmunológica de Órganos**
- **Como** Coordinador de la Unidad de Trasplantes,
- **quiero** registrar los órganos extraídos de donantes en el inventario especificando el grupo sanguíneo, raza y fecha de expiración,
- **para** garantizar la compatibilidad inmunológica y evitar que los órganos pierdan su viabilidad isquémica.
- **Criterios de Aceptación:**
  1. El sistema debe validar que la fecha de expiración ingresada sea posterior a la fecha y hora de registro.
  2. El sistema debe clasificar obligatoriamente el grupo sanguíneo del donante (A+, A-, B+, B-, AB+, AB-, O+, O-).
  3. Debe ser posible actualizar el estado clínico del órgano en inventario (de "viable" a "no viable" o "en proceso de asignación").

---

## 3. Módulo Epidemiológico y Clasificación de Patologías

### **UH-GE-303: Registro de Patologías con Clasificación Múltiple**
- **Como** Epidemiólogo en Jefe del Hospital,
- **quiero** registrar patologías en el catálogo general asociándolas a uno o varios tipos (ej. Infecciosa y Respiratoria),
- **para** reportar de manera exacta los casos epidemiológicos y facilitar los estudios clínicos de investigación.
- **Criterios de Aceptación:**
  1. Al registrar una patología, se debe poder seleccionar uno o múltiples tipos de clasificación del catálogo de patologías.
  2. El registro en la base de datos MySQL debe ser atómico: si falla la relación de alguno de los tipos, no debe guardarse la patología base en la tabla principal (transaccionalidad garantizada).
  3. El listado de patologías debe mostrar el nombre científico, nombre común, descripción y la lista completa de clasificaciones asociadas.

---

## 4. Módulo de Calidad y Atención al Paciente

### **UH-GE-304: Registro y Seguimiento de Quejas y Sugerencias**
- **Como** Gerente de Calidad y Atención al Paciente,
- **quiero** capturar las quejas y sugerencias en un buzón digital con su historial de seguimiento y derivación a departamentos,
- **para** dar una respuesta ágil a las incidencias de los usuarios y auditar los tiempos de resolución.
- **Criterios de Aceptación:**
  1. Al registrar la incidencia, si es de tipo "queja" el sistema debe inicializar el estado en `registrada` y si es "sugerencia" en `recibida`.
  2. Cada vez que se actualice el estado del trámite (registrada $\rightarrow$ en revisión $\rightarrow$ en proceso $\rightarrow$ atendida $\rightarrow$ cerrada $\rightarrow$ cancelada), se debe guardar automáticamente en el arreglo de seguimiento: la fecha del cambio, la acción, el ID del empleado que realiza la gestión y su comentario.
  3. El sistema debe permitir asociar la incidencia de manera opcional a un empleado clínico reportado (`personal_involucrado`) y obligatoriamente al departamento correspondiente de MySQL.

---

## 5. Módulo de Aprobaciones Gerenciales

### **UH-GE-305: Autorización de Solicitudes Especiales de Servicios**
- **Como** Subdirector Médico / Administrativo,
- **quiero** revisar las solicitudes pendientes de servicios especiales, cirugías complejas, traslados o campañas,
- **para** autorizar o rechazar su realización de acuerdo a la prioridad y el presupuesto institucional.
- **Criterios de Aceptación:**
  1. El sistema debe listar las solicitudes pendientes de aprobación mostrando el folio, el servicio solicitado, el solicitante, el costo unitario desglosado y la prioridad (baja, media, alta, urgente).
  2. Al cambiar el estado de la aprobación a "aprobado" o "rechazado", el sistema debe registrar obligatoriamente la firma electrónica lógica (ID y nombre del aprobador), la fecha y hora de respuesta, y un comentario justificativo.
