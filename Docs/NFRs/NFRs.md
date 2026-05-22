# Requerimientos No Funcionales (NFRs) - Área de Gerencia
**Hospital de Tercer Nivel (Alta Especialidad)**

Este documento especifica las propiedades de calidad, restricciones técnicas y requerimientos arquitectónicos que debe cumplir el sistema informático del área de **Gerencia** en el hospital de tercer nivel.

---

## 1. Arquitectura de Datos e Integración Híbrida

### **RNF-GE-201: Persistencia de Datos Híbrida (SQL + NoSQL)**
- **Descripción:** El sistema debe operar bajo un esquema de bases de datos híbrido para optimizar el rendimiento y la flexibilidad:
  - **Motor Relacional (MySQL):** Utilizado para catálogos altamente estructurados, estables y con relaciones complejas que exigen integridad referencial rígida (Áreas, Órganos, Patologías, Servicios).
  - **Motor No Relacional (MongoDB):** Utilizado para documentos de estructura variable, datos anidados y flujos de rápido cambio o auditoría histórica (Quejas y Sugerencias, Solicitudes de Servicios, Aprobaciones).

### **RNF-GE-202: Integridad Referencial Lógica**
- **Descripción:** Para las relaciones cruzadas entre colecciones de MongoDB y tablas de MySQL (ej. asociar una queja en MongoDB con una persona física y un departamento en MySQL), el sistema debe validar mediante lógica de programación de la API que los IDs foráneos existan antes de guardar el documento en MongoDB.

---

## 2. Rendimiento, Escalabilidad y Procesamiento de Datos

### **RNF-GE-203: Procesamiento por Lotes (Batch Processing)**
- **Descripción:** Para la importación, poblado masivo o migración de datos históricos (ej. registros masivos de quejas y sugerencias), el sistema debe fragmentar las transacciones en lotes (batch size) no mayores a **5,000 registros** simultáneos.
- **Justificación:** Prevenir el desbordamiento de memoria RAM y el bloqueo del ciclo de eventos (event loop) del servidor Node.js.

### **RNF-GE-204: Tiempo de Respuesta de la API**
- **Descripción:** El tiempo de respuesta de los endpoints de lectura estándar (GET `/areas`, GET `/patologias`, GET `/organos`) no debe exceder los **200 milisegundos** bajo condiciones normales de carga de la red hospitalaria.

### **RNF-GE-205: Eficiencia de Búsqueda mediante Indexación**
- **Descripción:** La colección de incidencias y solicitudes en MongoDB debe contar con índices definidos para los campos de filtrado y ordenamiento frecuentes:
  - Índice único sobre el `folio`.
  - Índice compuesto sobre la combinación de entidad (`entidad.tipo`, `entidad.id`) y `estatus` para las aprobaciones.
  - Índices individuales en `estatus`, `prioridad`, `servicio.id`, `area.id` y en la fecha de registro (`fechas.solicitud`).

---

## 3. Seguridad, Privilegios y Cumplimiento Regulatorio

### **RNF-GE-206: Control de Accesos Basado en Roles (RBAC)**
- **Descripción:** El acceso a la base de datos SQL del hospital debe estar estrictamente segregado por roles y usuarios para prevenir fugas de información y modificaciones no autorizadas:
  - El rol **`ge_user`** (Gerencia) solo tiene privilegios de INSERT, UPDATE, DELETE, REFERENCES y ALTER en las tablas de su área asignada (`tbc_areas`, `tbc_organos`, `tbc_patologias`, `tbc_servicios`, `tbd_aprobaciones` y `tbb_quejas_sugerencias`).
  - El rol **`ge_user`** tiene prohibido realizar modificaciones en las tablas de Recursos Humanos (`tbb_personal`, `tbd_horarios`), Expedientes Clínicos (`tbb_expedientes_medicos`, `tbb_diagnosticos`) o Finanzas del hospital de forma directa.
  - Los usuarios individuales de los desarrolladores gerenciales heredan los privilegios combinados del rol gerencial y del rol de lectura general (`developer`).

### **RNF-GE-207: Auditoría Automatizada no Repudiable**
- **Descripción:** Las acciones que alteren la estructura u operación de áreas, órganos y servicios en la base de datos SQL deben ser auditadas mediante disparadores (triggers) nativos a nivel de motor de base de datos, escribiendo de manera inmediata en la tabla `tbi_bitacora`. Esta tabla no permite modificaciones ni eliminaciones a ningún usuario clínico o administrativo.

---

## 4. Confiabilidad y Transaccionalidad

### **RNF-GE-208: Transaccionalidad ACID en MySQL**
- **Descripción:** Las escrituras complejas en la base de datos relacional (ej. el registro de patologías con sus relaciones muchos a muchos) deben ser atómicas. En caso de error, el middleware de conexión debe asegurar la ejecución de un `ROLLBACK` completo de la transacción.

### **RNF-GE-209: Resiliencia de Conexión a Base de Datos**
- **Descripción:** El pool de conexiones a MySQL (`mysql2/promise`) y la conexión de MongoDB (`mongoose`) deben implementar un mecanismo de reconexión automática en caso de pérdida temporal del enlace con el servidor de bases de datos.
