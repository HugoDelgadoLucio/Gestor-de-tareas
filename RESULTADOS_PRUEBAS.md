# Resultados de pruebas - etapa 4

**Fecha:** 23/11/2026

**Plataforma nativa utilizada:** 

La aplicación fue probada en las siguientes plataformas:

- Android
- Web
- Linux

**Versión del sistema operativo y dispositivo:** 

- Version de linux: Linux Mint Mate 22.3
- Version de Android: 14

**Navegador y versión:** Google Chrome 158.0.8127.36 

**Versión Flutter:** 3.47.5

**Resultado de `flutter analyze`:** Resultado completo de la ejecucion del comando

hugo@hugo-Lenovo-IdeaPad-S145-14API:~/Escritorio/Proyecto/gestor_tareas_local$ flutter analyze

Resolving dependencies... 

Downloading packages... 
  code_assets 1.2.1 (2.2.0 available)
  cupertino_icons 1.0.9 (2.0.0 available)
  hooks 2.0.2 (2.2.0 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.3 (1.19.0 available)
  native_toolchain_c 0.19.2 (0.19.6 available)
  objective_c 9.5.0 (9.6.4 available)
  record_use 0.6.0 (1.1.1 available)
  sqlite3 3.5.2 (3.9.2 available)
  test_api 0.7.12 (0.7.15 available)
  vector_math 2.4.0 (2.4.4 available)

Got dependencies!

11 packages have newer versions incompatible with dependency constraints.

Try `flutter pub outdated` for more information.

Analyzing gestor_tareas_local...                                        

No issues found! (ran in 3.0s)


---
**Resultado de `flutter test`:** Resultado completo de la ejecucion del comando

hugo@hugo-Lenovo-IdeaPad-S145-14API:~/Escritorio/Proyecto/gestor_tareas_local$ flutter test

Resolving dependencies... 

Downloading packages... 
  code_assets 1.2.1 (2.2.0 available)
  cupertino_icons 1.0.9 (2.0.0 available)
  hooks 2.0.2 (2.2.0 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.3 (1.19.0 available)
  native_toolchain_c 0.19.2 (0.19.6 available)
  objective_c 9.5.0 (9.6.4 available)
  record_use 0.6.0 (1.1.1 available)
  sqlite3 3.5.2 (3.9.2 available)
  test_api 0.7.12 (0.7.15 available)
  vector_math 2.4.0 (2.4.4 available)

Got dependencies!

11 packages have newer versions incompatible with dependency constraints.

Try `flutter pub outdated` for more information.

00:12 +7: All tests passed!  

---
---


| ID | Comprobación | Resultado |
|---|---|---|
| P1 | Crear tres tareas, cerrar y volver a abrir | Funcionamiento correcto |
| P2 | Completar una tarea y reiniciar | Funcionamiento correcto |
| P3 | Editar un título y reiniciar | Funcionamiento correcto |
| P4 | Eliminar una tarea y reiniciar | Funcionamiento correcto |
| P5 | Rechazar un título vacío o con espacios | Funcionamiento correcto |
| P6 | Recargar web y cerrar/abrir pestaña en mismo origen y perfil | Funcionamiento correcto |

## Plataformas verificadas

| Plataforma | Estado |
|---|---|
| Android | Verificado |
| iOS | Sin verificar |
| Windows | Sin verificar |
| Linux | Verificado |
| macOS | Sin verificar |
| Web (Chrome) | Verificado |

## Incidencias y solución

## Incidencias encontradas y soluciones aplicadas

### 1. Error de conexión a SQLite en Chrome

**Incidencia:** Al ejecutar la aplicación en Google Chrome, la interfaz cargaba correctamente, pero aparecía un mensaje indicando que no se podía conectar a la base de datos. En la terminal se mostraba un error relacionado con WebAssembly y el tipo MIME del archivo.

**Solución:** Se revisó la configuración de SQLite Web y se identificó que los archivos necesarios para su funcionamiento no estaban disponibles correctamente. Se ajustó el script de preparación para descargar y verificar los recursos `sqlite3.wasm` y `drift_worker.dart.js`, necesarios para utilizar SQLite desde el navegador.

### 2. Error al editar el título de una tarea en Android

**Incidencia:** Al intentar modificar el nombre de una tarea y presionar el botón de guardar, la aplicación mostraba un error de Flutter relacionado con `_dependents.isEmpty`, impidiendo completar correctamente la edición.

**Solución:** Se revisó el manejo del formulario de edición y se encontró un problema con el ciclo de vida del `TextEditingController`. Se modificó el formulario para administrar correctamente el controlador y evitar que fuera liberado mientras todavía estaba siendo utilizado por la interfaz.

### 3. Error en las pruebas automatizadas

**Incidencia:** Al ejecutar `flutter test`, una de las pruebas fallaba y mostraba el mensaje `A TextEditingController was used after being disposed`. Además, la prueba no encontraba una tarea que debía aparecer después de agregarla.

**Solución:** Se corrigió el manejo del controlador de texto dentro del formulario y se ajustó su liberación para evitar errores durante la reconstrucción de la interfaz. Posteriormente se prepararon nuevamente las pruebas para comprobar las operaciones CRUD.

### 4. Advertencia al ejecutar flutter analyze

**Incidencia:** Al ejecutar `flutter analyze`, apareció una advertencia indicando que el parámetro `conexion` del constructor de `TareasDatabase` podía declararse como un parámetro de la clase padre.

**Solución:** Se simplificó la declaración del constructor utilizando la sintaxis de superparámetros de Dart, eliminando código innecesario y siguiendo las recomendaciones del analizador.


