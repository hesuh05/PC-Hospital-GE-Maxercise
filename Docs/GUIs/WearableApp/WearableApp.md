# WearableApp - Interface Gráfica

Documentación de diseño de interfaz para la aplicación Wearable del proyecto PC-Hospital-UDN-Gerencia.

## Descripción

Esta carpeta contiene el diseño, mockups y especificaciones de la interfaz gráfica para la aplicación wearable, optimizada para dispositivos portátiles como relojes inteligentes y pulseras fitness.

## Características de la Aplicación Wearable

### Pantalla Limitada
- Resoluciones pequeñas (240x240 a 454x454 píxeles típicamente)
- Adaptar información esencial
- Jerarquía clara de contenido

### Interacción Simplificada
- Pocos toques requeridos
- Navegación mediante botones
- Gestos minimales (deslizar, presionar)

### Funcionalidades Clave
- **Monitoreo en tiempo real**: Frecuencia cardíaca, pasos, etc.
- **Notificaciones**: Alertas de pacientes o citas
- **Registro rápido**: Entrada de datos mínima
- **Ver Historial**: Acceso a datos recientes
- **Control de dispositivo**: Sincronización y ajustes

## Diseño Responsivo

Se debe soportar múltiples tamaños:
- Relojes redondos: 240x240, 280x280, 360x360
- Relojes rectangulares: 240x320, 454x454
- Pulseras fitness: 128x64, 160x80

## Elementos de UI

### Navegación
- Menú principal simplificado
- Breadcrumbs para contexto
- Botones de acción claros

### Visualización de Datos
- Gráficos simples y legibles
- Indicadores visuales (colores, iconos)
- Números grandes y claros

### Feedback
- Vibración táctil
- Tonos de alerta
- Animaciones suaves

## Principios de Diseño para Wearables

1. **Minimalismo**: Solo información esencial
2. **Velocidad**: Acceso rápido a funciones críticas
3. **Contexto**: Mostrar información relevante al momento
4. **Accesibilidad**: Texto suficientemente grande
5. **Batería**: Diseño eficiente en consumo de energía

## Archivos Incluidos

- Wireframes de pantallas principales
- Mockups visuales
- Especificaciones de componentes
- Guía de interacciones
- Patrones de flujo

## Audiencia

- Diseñadores móvil/wearable
- Desarrolladores de apps
- Product managers
- Profesionales de salud (usuarios)

## Plataformas Objetivo

- Wear OS (Google)
- watchOS (Apple)
- Plataformas Android wear
- Pulseras fitness propietarias

## Notas de Implementación

- Optimizar para batería limitada
- Considerar connectivity intermitente
- Diseñar para uso con guantes
- Minimizar transferencia de datos
- Testing en dispositivos reales
