# Requerimientos Funcionales (FRs) - Área de Gerencia
**Hospital de Tercer Nivel (Alta Especialidad)**

Este documento describe las funciones específicas que el sistema informático debe realizar para el área de **Gerencia**, basándose en la configuración de base de datos híbrida (SQL + NoSQL) y los endpoints provistos en la API del hospital.

---

## 1. Módulo de Gestión de Áreas Hospitalarias (SQL)

### **RF-GE-101: Alta de Áreas**
- **Descripción:** El sistema debe permitir el registro de una nueva área del hospital.
- **Entradas:** Nombre (único), descripción, identificador de ubicación (`Ubicacion_ID`), identificador del personal responsable (`Personal_ID_Responsable`), e identificador opcional del área jerárquica superior (`Area_Superior_ID`).
- **Comportamiento:**
  - Validar que el nombre del área no esté duplicado.
  - Asignar de manera automática el `Estatus = 1` (activo) y la fecha de registro actual.
  - Registrar la acción en la bitácora de auditoría.

### **RF-GE-102: Consulta y Listado de Áreas Activas**
- **Descripción:** El sistema debe devolver la lista de todas las áreas hospitalarias que se encuentran activas en el sistema (`Estatus = 1`).
- **Detalle de Salida:** ID, Nombre, Descripción, Estado Operativo (Activa, Inactiva, Suspendida, Cancelada) y el Total de Empleados asignados.

### **RF-GE-103: Modificación del Estatus Operativo**
- **Descripción:** El sistema debe permitir actualizar los datos descriptivos y el estado operativo del área.
- **Regla:** Si se altera el estado a `Suspendida` o `Inactiva`, se debe disparar una alerta a la jefatura médica del área y registrarse en la bitácora.

### **RF-GE-104: Baja Lógica de Áreas**
- **Descripción:** El sistema debe realizar una desactivación lógica de un área, cambiando su atributo `Estatus` a `0`.
- **Regla:** No se permite borrar físicamente el registro de la base de datos MySQL.

---

## 2. Módulo de Trasplantes y Catálogo de Órganos (SQL)

### **RF-GE-105: Registro de Órganos en Catálogo**
- **Descripción:** El sistema debe permitir catalogar los órganos médicos susceptibles de trasplante en el hospital.
- **Datos:** Nombre, Sistema/Aparato al que pertenece, Requisitos clínicos de compatibilidad, Descripción, Función fisiológica y Stock inicial.

### **RF-GE-106: Control de Inventario de Órganos Donados**
- **Descripción:** El sistema debe registrar de forma individual cada órgano extraído en el inventario activo.
- **Datos:** ID del Órgano (relacionado con el catálogo), Fecha de Expiración (viabilidad), Estado clínico (Viable, No Viable, En Proceso), Raza (datos demográficos/etnicidad del donante), Grupo Sanguineo del donante y Observaciones clínicas.
- **Comportamiento:** Validar la coherencia del grupo sanguíneo ingresado (debe coincidir con la lista de tipos válidos).

---

## 3. Módulo Epidemiológico y Clasificación de Patologías (SQL)

### **RF-GE-107: Registro Transaccional de Patologías con Clasificación Múltiple**
- **Descripción:** El sistema debe permitir el registro de una patología asociándole múltiples categorías o tipos.
- **Comportamiento:** La operación debe ejecutarse dentro de una transacción única de base de datos. Si falla la inserción de la patología o de alguna de sus clasificaciones en la tabla intermedia (`tbd_ge_patologias_tipos`), toda la operación debe revertirse (rollback).

### **RF-GE-108: Consulta Agrupada de Clasificaciones de Patología**
- **Descripción:** Al listar las patologías, el sistema debe concatenar y mostrar todas las clasificaciones de tipos que pertenecen a la misma (ej. mostrar: "Gastrointestinal, Infecciosa" para la Salmonelosis) mediante un agrupamiento (GROUP BY) y concatenación de registros.

---

## 4. Módulo de Atención al Paciente - Quejas y Sugerencias (NoSQL - MongoDB)

### **RF-GE-109: Registro Flexible de Incidencias**
- **Descripción:** El sistema debe permitir almacenar quejas y sugerencias en una colección orientada a documentos de MongoDB.
- **Datos del Documento:** Folio único auto-generado, tipo (queja/sugerencia), categoría, prioridad (baja, media, alta, urgente), descripción detallada, datos embebidos de la persona física (ID y nombre completo), departamento de ocurrencia (ID y nombre), canal de recepción (buzón, web, teléfono, presencial, app), estatus e historial de seguimiento.

### **RF-GE-110: Generación Automática del Historial y Cambio de Estados**
- **Descripción:** Al modificar el estatus de una queja o sugerencia, el sistema debe registrar en un arreglo interno (`seguimiento`) el log del cambio, con la fecha actual, la acción realizada, el ID del empleado que resolvió y comentarios adicionales.

### **RF-GE-111: Simulador y Poblador de Datos de Rendimiento**
- **Descripción:** La API debe proveer un endpoint para la generación controlada de grandes volúmenes de incidencias (quejas/sugerencias) con distribución ponderada realista (ej. asignando 5 veces más probabilidad de ocurrencia en áreas de alta afluencia como Urgencias y Consulta Externa) para pruebas de carga.

---

## 5. Módulo de Autorizaciones y Solicitudes de Servicios (NoSQL - MongoDB)

### **RF-GE-112: Creación de Solicitudes de Servicios con Costo Embebido**
- **Descripción:** El sistema debe registrar las peticiones de servicios especiales de salud, guardando un snapshot del costo (monto unitario, cantidad, descuento, total) aplicable en el momento de la solicitud.

### **RF-GE-113: Autorización y Registro de Aprobaciones**
- **Descripción:** El sistema debe permitir a la Dirección o Gerencia autorizar o rechazar solicitudes de servicios, cirugías, traslados o campañas registradas en MongoDB.
- **Comportamiento:** Al actualizar una aprobación, el sistema debe guardar el estatus ("aprobado", "rechazado", "cancelado"), registrar el ID del aprobador y la fecha/hora exacta de la respuesta.
