# Manual de Instalación y Despliegue de la API - Hospital Área Gerencia

Este manual detalla paso a paso el proceso de instalación, configuración y despliegue de la **API de Gerencia Hospitalaria**. Esta API cuenta con una **arquitectura híbrida** que interactúa simultáneamente con bases de datos relacionales (**MySQL**) y no relacionales (**MongoDB**).

---

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente en el servidor o entorno local de desarrollo:

1. **Node.js**: Versión LTS recomendada (v18.x o superior).
2. **NPM**: Gestor de paquetes de Node (incluido por defecto con Node.js).
3. **MySQL Server**: Versión 8.0 o superior (puerto por defecto del proyecto: `3307`, configurable).
4. **MongoDB Server**: Versión 5.0 o superior, o una instancia de MongoDB Atlas.

---

## Estructura del Proyecto

El repositorio principal está dividido en tres áreas fundamentales:

*   **`api-hospital-gerencia/`**: Código fuente de la API desarrollado en Node.js, Express y Mongoose.
*   **`SQL/`**: Definición de esquemas relacionales, respaldos de estructura, datos y scripts administrativos.
*   **`NoSQL/`**: Esquemas de documentos JSON, validadores de MongoDB y respaldos de la base de datos documental.

---

## Paso 1: Instalación de Dependencias del Backend

Navega hasta el directorio del backend e instala todos los paquetes necesarios del proyecto.

```bash
cd api-hospital-gerencia
npm install
```

Esto instalará dependencias clave como `express`, `mongoose`, `mysql2`, `dotenv`, `swagger-ui-express`, `cors`, `helmet`, entre otras.

---

## Paso 2: Configuración de Variables de Entorno (`.env`)

Dentro de la carpeta `api-hospital-gerencia`, debes crear un archivo llamado `.env` para almacenar las credenciales de conexión.

### Variables requeridas:

| Variable | Descripción | Valor por Defecto / Ejemplo |
| :--- | :--- | :--- |
| `PORT` | Puerto en el que correrá el servidor Express | `3000` |
| `DB_HOST` | Host del servidor MySQL | `127.0.0.1` |
| `DB_USER` | Usuario de conexión a MySQL | `root` |
| `DB_PASSWORD` | Contraseña del usuario de MySQL | `1234` |
| `DB_NAME` | Nombre de la base de datos en MySQL | `hospital_230028` |
| `DB_PORT` | Puerto del servidor MySQL | `3307` |
| `MONGO_URI` | Cadena de conexión a MongoDB | `mongodb://127.0.0.1:27017/hospital_gerencia` |

### Plantilla de ejemplo (`.env`):
Copia el siguiente contenido en tu archivo `api-hospital-gerencia/.env` y personaliza los valores según tu infraestructura:

```env
PORT=3000
DB_HOST=127.0.0.1
DB_USER=root
DB_PASSWORD=tu_contraseña_aqui
DB_NAME=hospital_230028
DB_PORT=3306
MONGO_URI=mongodb://127.0.0.1:27017/hospital_gerencia
```

---

## Paso 3: Despliegue de la Base de Datos SQL (MySQL)

El sistema relacional almacena las tablas catálogo (Áreas, Órganos, Patologías, Servicios) e información transaccional.

### 1. Crear la Base de Datos
Accede a tu gestor MySQL (CLI, Workbench, DBeaver) y ejecuta:
```sql
CREATE DATABASE hospital_230028;
```
*(Asegúrate de que este nombre sea el mismo configurado en la variable `DB_NAME` del archivo `.env`).*

### 2. Importar la Estructura (Esquema DDL)
Importa el esquema de tablas desde el archivo de respaldo estructural ubicado en el repositorio:
*   **Ruta del archivo:** `SQL/db/backups/Structure/backup_estructura20260324.sql`

**Comando CLI:**
```bash
mysql -u [usuario] -p hospital_230028 < SQL/db/backups/Structure/backup_estructura20260324.sql
```
*(O arrastra el archivo SQL a tu herramienta gráfica favorita y ejecútalo sobre la BD creada).*

### 3. Cargar los Datos Iniciales (DML)
Debido al volumen de registros (+1 millón de filas), los datos no están versionados directamente en GitHub. Descarga el respaldo correspondiente en los siguientes enlaces oficiales del proyecto:

*   **Opción A (Recomendado - 09/03/2026):** [Descargar Backup de Datos desde Google Drive](https://drive.google.com/file/d/1jUlc55HUYPpXeQwbjO-4FldKjOulbBrI/view?usp=sharing)
    *   *Incluye:* `tbb_hr_personas`, `tbb_hr_personas_fisicas`, `tbb_md_pacientes`.
*   **Opción B (Versión anterior - 19/02/2026):** [Descargar Backup de Datos desde Google Drive](https://drive.google.com/file/d/1l4dll9jst0SaG0kQmKTomTlml4dySl_U/view?usp=sharing)
    *   *Incluye:* `tbb_personas`, `tbb_personas_fisicas`, `tbb_pacientes`.

**Comando CLI para importar los datos descargados:**
```bash
mysql -u [usuario] -p hospital_230028 < [Ruta_del_archivo_descargado].sql
```

### 4. Configurar Roles y Privilegios
El proyecto incluye un script para definir los accesos operativos del hospital:
*   **Ruta del archivo:** `SQL/db/scripts/roles_privileges.sql`

> [!WARNING]
> El script `roles_privileges.sql` del repositorio utiliza por defecto la base de datos `hospital_230052` en sus instrucciones `GRANT`. 
> Si tu base de datos se llama diferente (ej. `hospital_230028`), deberás abrir el archivo SQL y reemplazar globalmente `hospital_230052` por tu nombre de base de datos antes de ejecutarlo.

**Comando CLI:**
```bash
mysql -u root -p < SQL/db/scripts/roles_privileges.sql
```

---

## Paso 4: Despliegue de la Base de Datos NoSQL (MongoDB)

La base de datos documental se encarga de almacenar colecciones flexibles e integraciones del área de gerencia (Quejas y Sugerencias, Solicitudes de Servicios y Aprobaciones).

### 1. Iniciar MongoDB
Asegúrate de tener el servicio activo en tu servidor local:
```bash
# En Windows (si está instalado como servicio)
net start MongoDB

# En Linux / macOS
sudo systemctl start mongod
```

### 2. Cargar Respaldo de Datos (Opcional)
Si necesitas la colección `quejas_sugerencias` inicial cargada con más de 500,000 documentos de prueba:
1.  **Descarga el respaldo:** [Descargar Backup MongoDB desde Google Drive](https://drive.google.com/drive/folders/1kUFQgzkNEOC42cnBYsvInpauA0pSXeAi?usp=drive_link)
2.  Importa el backup utilizando la herramienta `mongorestore` sobre tu URI de conexión:
```bash
mongorestore --uri="mongodb://127.0.0.1:27017/hospital_gerencia" [Ruta_de_la_carpeta_descargada]
```

*(Nota: Si no deseas importar este respaldo de datos pesados, puedes auto-generar datos utilizando los endpoints de población que se describen a continuación).*

---

## Paso 5: Poblado de Datos mediante API (Seeding)

La API cuenta con endpoints específicos para generar datos simulados masivos de manera rápida y consistente utilizando Faker.

Una vez que la API esté corriendo (ver Paso 6), puedes poblar las distintas bases de datos llamando a los siguientes endpoints vía POST (usando Postman, Insomnia o Swagger):

1.  **Poblar todo el sistema secuencialmente:**
    *   `POST /gerencia/todo/poblar`
2.  **Poblar áreas:**
    *   `POST /gerencia/areas/poblar`
3.  **Poblar órganos catalogados:**
    *   `POST /gerencia/organos/poblar`
4.  **Poblar inventario de órganos:**
    *   `POST /gerencia/inventario/poblar`
5.  **Poblar patologías y sus tipos:**
    *   `POST /gerencia/patologias/poblar`
    *   `POST /gerencia/tipos/patologia/poblar`
6.  **Poblar Quejas y Sugerencias (MongoDB) de forma masiva:**
    *   `POST /gerencia/quejas-sugerencias/poblar`
    *   *Payload Ejemplo:* `{"cantidad": 15000}` (Soporta miles de registros de forma asíncrona optimizada).
7.  **Poblar Pacientes (MySQL) a través del Store Procedure:**
    *   `POST /gerencia/pacientes/poblar`
    *   *Payload Ejemplo:*
        ```json
        {
          "p_cantidad": 10000,
          "p_c_genero": null,
          "p_edad_minima": null,
          "p_edad_maxima": null,
          "p_estatus_vida": null,
          "p_modo_estatus_medico": -1,
          "p_estatus_medico": null,
          "p_tipo_edad": null,
          "p_modo_situacion_medica": 0,
          "p_situacion_medica": null,
          "p_modo_titulo": null
        }
        ```

---

## Paso 6: Ejecución de la API

Regresa a la carpeta raíz del servidor (`api-hospital-gerencia`) y levanta el servicio:

### Modo Desarrollo
Levanta la API utilizando `nodemon` para que se reinicie automáticamente con cada cambio:
```bash
npm run dev
```

### Modo Producción
Levanta la API de forma nativa con Node.js:
```bash
npm start
```

### Comprobación de Conexión Híbrida
Al iniciar, la API realiza un proceso de validación secuencial:
1. Intenta conectarse a **MongoDB**. Si tiene éxito, muestra: `1/2 Conexión a MongoDB Exitosa (Área Gerencia)`.
2. Realiza una consulta de prueba `SELECT 1` en **MySQL**. Si tiene éxito, muestra: `2/2 Conexión a MySQL Exitosa`.
3. Inicia el servidor Express.

> [!CRITICAL]
> Si alguno de los dos motores de bases de datos falla en la conexión, la API lanzará un **ERROR CRÍTICO** en la consola y se detendrá inmediatamente (`process.exit(1)`). Revisa el archivo `.env` y el estado de tus servidores si esto ocurre.

---

## Paso 7: Acceso a la Documentación (Swagger)

Con la API en funcionamiento, puedes abrir tu navegador y dirigirte a:

**[http://localhost:3000/api-docs](http://localhost:3000/api-docs)** *(o el puerto que hayas configurado).*

Desde esta interfaz interactiva podrás:
*   Visualizar todos los endpoints públicos clasificados por áreas (Pacientes, Áreas, Órganos, Aprobaciones, Accesos, MongoDB, etc.).
*   Probar solicitudes HTTP en tiempo real con payloads precargados.
*   Consultar los esquemas y modelos de datos relacionales y no relacionales.

---

## Solución de Problemas Comunes (Troubleshooting)

*   **Error: `ERROR CRÍTICO AL INICIAR EL SISTEMA: Access denied for user...`**
    *   *Causa:* Las credenciales de MySQL en tu archivo `.env` no son correctas.
    *   *Solución:* Verifica `DB_USER` y `DB_PASSWORD`. Asegúrate de que el puerto `DB_PORT` sea el correcto (algunas configuraciones usan `3306` y otras `3307`).
*   **Error: `Error conectando a MongoDB: connect ECONNREFUSED`**
    *   *Causa:* El servicio de MongoDB no está activo o la dirección IP de `MONGO_URI` está mal especificada.
    *   *Solución:* Levanta el servicio MongoDB o revisa si tu proveedor de nube requiere configuración de lista blanca de IPs.
*   **Error: `Table 'hospital_230028.tbc_areas' doesn't exist`**
    *   *Causa:* Has iniciado la API sin antes importar el archivo estructural DDL de MySQL.
    *   *Solución:* Sigue las instrucciones del Paso 3 para importar la estructura de la base de datos.
