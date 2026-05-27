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
*   **Ruta del archivo en el repositorio:** `DataBases/SQL/Backups/latest_structural_backup.sql`
*   **Nota:** este es el único archivo de esquema SQL versionado actualmente en el repositorio.

**Comando CLI (desde la raíz del repositorio):**
```bash
mysql -u [usuario] -p hospital_230028 < DataBases/SQL/Backups/latest_structural_backup.sql
```
> **Nota:** si ejecutas el comando desde otra carpeta, ajusta la ruta al archivo SQL según tu ubicación actual.
>
> **Nota adicional para MySQL Workbench:** si la importación falla usando la opción `Import` y seleccionando el archivo, prueba a abrir `latest_structural_backup.sql` como texto, copiar todo su contenido y pegarlo en una pestaña nueva de consulta (`query window`) para ejecutarlo desde allí.
*(O arrastra el archivo SQL a tu herramienta gráfica favorita y ejecútalo sobre la BD creada).*

### 3. Cargar los Datos Iniciales (DML) — Opcional
Los datos transaccionales (DML) no están incluidos en el repositorio debido a su tamaño. Si necesitas poblaciones reales, puedes:

- Descargar los backups oficiales (si están disponibles) desde las fuentes externas mantenidas por el equipo.
- O bien utilizar los endpoints de población incluidos en la API para generar datos sintéticos coherentes y reproducibles (recomendado para pruebas y entornos locales).

Si tienes un respaldo externo: importa el `.sql` mediante tu cliente preferido o con el comando CLI mostrado en la sección anterior, ajustando la ruta al archivo.

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