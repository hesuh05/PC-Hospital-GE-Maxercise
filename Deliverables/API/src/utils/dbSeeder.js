const { fakerES_MX: faker } = require('@faker-js/faker');
const pool = require('../config/database');

const inicializarCatalogos = async () => {
  const connection = await pool.getConnection();
  try {
    // 1. ROMPER LA DEPENDENCIA CIRCULAR apagando las llaves foráneas temporalmente
    await connection.query('SET FOREIGN_KEY_CHECKS = 0;');
    console.log('Validación de FK desactivada temporalmente...');

    // Limpiamos las tablas (Opcional, pero recomendado para un clean start en pruebas)
    await connection.query('TRUNCATE TABLE tbb_hr_personal;');
    await connection.query('TRUNCATE TABLE tbb_hr_personas_fisicas;');
    await connection.query('TRUNCATE TABLE tbb_hr_personas;');
    await connection.query('TRUNCATE TABLE tbc_hr_departamentos;');
    await connection.query('TRUNCATE TABLE tbc_ge_areas;');

    // ==========================================
    // 2. CREAR 100 PACIENTES (Personas Físicas puras)
    // ==========================================
    console.log('Generando 100 pacientes (Personas Físicas)...');
    for (let i = 0; i < 100; i++) {
      const [resPersona] = await connection.query(
        `INSERT INTO tbb_hr_personas (tipo, rfc, pais_origen, estatus) VALUES ('Fisica', ?, 'México', 1)`,
        [faker.string.alphanumeric({ length: 13, casing: 'upper' })]
      );
      
      await connection.query(
        `INSERT INTO tbb_hr_personas_fisicas 
        (ID, titulo_cortesia, nombre, primer_apellido, segundo_apellido, genero, fecha_nacimiento, curp, grupo_sanguineo, estatus) 
        VALUES (?, 'C.', ?, ?, ?, ?, ?, ?, 'O+', 1)`,
        [
          resPersona.insertId, 
          faker.person.firstName(), 
          faker.person.lastName(), 
          faker.person.lastName(),
          faker.helpers.arrayElement(['H', 'M']),
          faker.date.birthdate({ min: 18, max: 80, mode: 'age' }),
          faker.string.alphanumeric({ length: 18, casing: 'upper' })
        ]
      );
    }

    // ==========================================
    // 3. CREAR 6 DIRECTORES DE ÁREA Y SUS ÁREAS
    // ==========================================
    console.log('Generando Directores y Áreas...');
    const areasData = [
      { id: 1, nom: 'Gerencia', desc: 'Dirección general', emp: 5 },
      { id: 2, nom: 'Recursos Humanos', desc: 'Gestión y reclutamiento', emp: 15 },
      { id: 3, nom: 'Farmacia', desc: 'Suministro de medicamentos', emp: 25 },
      { id: 4, nom: 'Registros Medicos', desc: 'Control de expedientes', emp: 20 },
      { id: 5, nom: 'Recursos Materiales', desc: 'Adquisiciones', emp: 30 },
      { id: 6, nom: 'Servicios Medicos', desc: 'Coordinación clínica', emp: 200 }
    ];

    for (const area of areasData) {
      // Crear Director
      const [resP] = await connection.query(`INSERT INTO tbb_hr_personas (tipo, rfc, pais_origen, estatus) VALUES ('Fisica', ?, 'México', 1)`, [faker.string.alphanumeric(13).toUpperCase()]);
      const directorId = resP.insertId;
      await connection.query(
        `INSERT INTO tbb_hr_personas_fisicas (ID, titulo_cortesia, nombre, primer_apellido, segundo_apellido, genero, fecha_nacimiento, curp, grupo_sanguineo, estatus) VALUES (?, 'Dr.', ?, ?, ?, 'N/B', '1975-05-10', ?, 'O+', 1)`,
        [directorId, faker.person.firstName(), faker.person.lastName(), faker.person.lastName(), faker.string.alphanumeric(18).toUpperCase()]
      );
      await connection.query(
        `INSERT INTO tbb_hr_personal (ID, Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Salario, Estatus) VALUES (?, 1, ?, 'Director de Área', 'BASE', '2015-01-01', 45000, 1)`,
        [directorId, faker.number.int({ min: 1000, max: 2000 })]
      );

      // Crear el Área asignándole este Director
      await connection.query(
        `INSERT INTO tbc_ge_areas (ID, Nombre, Descripcion, Espacio_ID, Personal_Responsable_ID, Area_Superior_ID, Estatus_Operacion, Total_Empleados) VALUES (?, ?, ?, ?, ?, ?, 'Activa', ?)`,
        [area.id, area.nom, area.desc, area.id + 100, directorId, area.id === 1 ? null : 1, area.emp]
      );
    }

    // ==========================================
    // 4. CREAR JEFES DE DEPARTAMENTO Y DEPARTAMENTOS
    // ==========================================
    console.log('Generando Jefes y Departamentos...');
const departamentosData = [
      { nombre: 'Urgencias', areaId: 6 }, // ID 1
      { nombre: 'Laboratorio', areaId: 6 }, // ID 2
      { nombre: 'Caja y Facturación', areaId: 1 }, // ID 3
      { nombre: 'Reclutamiento', areaId: 2 }, // ID 4
      { nombre: 'Almacén de Farmacia', areaId: 3 }, // ID 5
      { nombre: 'Archivo Clínico', areaId: 4 }, // ID 6 
      { nombre: 'Compras y Suministros', areaId: 5 }, // ID 7 
      // --- ¡Los que faltaban según tu base de datos! ---
      { nombre: 'Quirófano', areaId: 6 }, // ID 8
      { nombre: 'Pediatría', areaId: 6 }, // ID 9
      { nombre: 'Oncología', areaId: 6 }, // ID 10
      { nombre: 'Mantenimiento', areaId: 1 }, // ID 11
      { nombre: 'Consulta Externa', areaId: 6 } // ID 12
    ];

    for (const depto of departamentosData) {
      // Crear Jefe de Departamento
      const [resP] = await connection.query(`INSERT INTO tbb_hr_personas (tipo, rfc, pais_origen, estatus) VALUES ('Fisica', ?, 'México', 1)`, [faker.string.alphanumeric(13).toUpperCase()]);
      const jefeId = resP.insertId;
      await connection.query(
        `INSERT INTO tbb_hr_personas_fisicas (ID, titulo_cortesia, nombre, primer_apellido, segundo_apellido, genero, fecha_nacimiento, curp, grupo_sanguineo, estatus) VALUES (?, 'Lic.', ?, ?, ?, 'N/B', '1985-08-20', ?, 'A+', 1)`,
        [jefeId, faker.person.firstName(), faker.person.lastName(), faker.person.lastName(), faker.string.alphanumeric(18).toUpperCase()]
      );
      await connection.query(
        `INSERT INTO tbb_hr_personal (ID, Departamento_ID, Numero_Empleado, Puesto, Tipo_Contrato, Fecha_Ingreso, Salario, Estatus) VALUES (?, 1, ?, 'Jefe de Departamento', 'BASE', '2018-03-15', 25000, 1)`,
        [jefeId, faker.number.int({ min: 2001, max: 4000 })]
      );

      // Crear el Departamento asignándole este Jefe
      await connection.query(
        `INSERT INTO tbc_hr_departamentos (Nombre, Descripcion, Area_Id, Responsable_Personal_ID, Estatus) VALUES (?, ?, ?, ?, 1)`,
        [depto.nombre, `Depto de ${depto.nombre}`, depto.areaId, jefeId] 
      );
    }

    console.log('✅ Base de datos sembrada con 100 pacientes, 6 Directores, 5 Jefes, Áreas y Departamentos reales.');

  } catch (error) {
    console.error('❌ Error durante la siembra de base de datos:', error);
    throw error;
  } finally {
    // 5. REACTIVAR LAS LLAVES FORÁNEAS
    await connection.query('SET FOREIGN_KEY_CHECKS = 1;');
    console.log('Validación de FK reactivada.');
    connection.release();
  }
};

const inicializarServicios = async () => {
  const connection = await pool.getConnection();
  try {
    console.log('Generando catálogo de Servicios...');
    
    await connection.query('SET FOREIGN_KEY_CHECKS = 0;');
    await connection.query('TRUNCATE TABLE tbc_ge_servicios;');

    // ¡Aquí están los servicios que SÍ coinciden con tus áreas del 1 al 6!
    const serviciosData = [
      { areaId: 6, nom: 'Consulta Medicina General', desc: 'Valoración clínica de primer contacto', nivel: 'Basico', costo: 1 },
      { areaId: 6, nom: 'Resonancia Magnética', desc: 'Estudio de imagenología avanzada', nivel: 'Especializado', costo: 1 },
      { areaId: 6, nom: 'Hemodiálisis', desc: 'Terapia de reemplazo renal', nivel: 'Alta Especialidad', costo: 1 },
      { areaId: 6, nom: 'Cirugía Cardiovascular', desc: 'Procedimiento quirúrgico de corazón abierto', nivel: 'Alta Especialidad', costo: 1 },
      { areaId: 6, nom: 'Atención en Triage', desc: 'Clasificación de urgencias', nivel: 'Basico', costo: 0 },
      { areaId: 3, nom: 'Surtimiento de Receta', desc: 'Dispensación de medicamentos en ventanilla', nivel: 'Basico', costo: 0 },
      { areaId: 4, nom: 'Copias de Expediente Clínico', desc: 'Emisión de duplicados físicos del historial', nivel: 'Basico', costo: 1 },
      { areaId: 2, nom: 'Evaluación Psicométrica', desc: 'Prueba psicológica para reclutamiento', nivel: 'Basico', costo: 0 },
      { areaId: 5, nom: 'Mantenimiento Preventivo', desc: 'Revisión y calibración de equipo médico', nivel: 'Basico', costo: 0 },
      { areaId: 1, nom: 'Auditoría de Calidad', desc: 'Revisión interna de estándares hospitalarios', nivel: 'Especializado', costo: 0 }
    ];

    for (const serv of serviciosData) {
      await connection.query(
        `INSERT INTO tbc_ge_servicios (Area_ID, Nombre, Descripcion, Nivel, Costo, Fecha_Registro, Fecha_Actualizacion, Estatus) 
         VALUES (?, ?, ?, ?, ?, NOW(), NOW(), b'1')`,
        [serv.areaId, serv.nom, serv.desc, serv.nivel, serv.costo]
      );
    }

    console.log('✅ Catálogo de servicios sembrado exitosamente con 10 servicios base.');

  } catch (error) {
    console.error('❌ Error durante la siembra de servicios:', error);
    throw error;
  } finally {
    await connection.query('SET FOREIGN_KEY_CHECKS = 1;');
    connection.release();
  }
};

module.exports = { 
  inicializarCatalogos,
  inicializarServicios
};