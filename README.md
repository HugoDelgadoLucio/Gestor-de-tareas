# Gestor de tareas con SQLite

## Descripción

Aplicación desarrollada con Flutter para administrar tareas utilizando una base de datos SQLite local. El proyecto forma parte de la práctica de persistencia local multiplataforma de la materia Programación de Dispositivos Móviles.

La aplicación está diseñada para funcionar en Android, iOS, Windows, Linux, macOS y web, sin depender de un servidor externo para almacenar las tareas.

## Tecnología utilizada

- Flutter y Dart para el desarrollo de la aplicación.
- SQLite para el almacenamiento local de las tareas.
- Drift y drift_flutter para gestionar las operaciones sobre la base de datos.
- WebAssembly para ejecutar SQLite en navegadores web.

Se eligió SQLite porque permite conservar la información entre ejecuciones de la aplicación, a diferencia de una lista almacenada únicamente en memoria.

## Diseño de la base de datos

La aplicación utiliza una tabla llamada `tareas`.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT | Identificador único de la tarea |
| titulo | TEXT NOT NULL | Nombre de la tarea |
| completada | INTEGER NOT NULL DEFAULT 0 | Estado: 0 pendiente, 1 completada |

El identificador se genera automáticamente para distinguir cada registro.

## Etapa 1. Preparación y diseño

Se preparó el proyecto inicial de Flutter, se revisó su estructura y se seleccionó SQLite con Drift como tecnología de persistencia.

También se definió la estructura de la tabla `tareas` y las operaciones que posteriormente utilizará la aplicación.

## Etapa 2. Persistencia real

Se incorporó la conexión a SQLite y se implementaron las siguientes operaciones:

**Alta de tareas**

Permite introducir el título de una tarea y almacenarla en SQLite mediante una instrucción `INSERT`. Se valida que el título no esté vacío ni contenga únicamente espacios.

**Consulta de tareas**

Permite obtener mediante `SELECT` las tareas almacenadas y mostrarlas en pantalla, incluyendo su estado.

Los datos se almacenan localmente para que permanezcan disponibles después de cerrar y volver a abrir la aplicación.

## Estructura del proyecto

- `lib/main.dart`: inicialización de la aplicación.
- `lib/models/tarea.dart`: modelo de datos de las tareas.
- `lib/data/tareas_database.dart`: conexión SQLite y operaciones de persistencia.
- `lib/screens/tareas_page.dart`: interfaz para agregar y consultar tareas.
- `test/`: pruebas automatizadas.
- `tool/`: scripts de preparación para SQLite Web.

## Instalación y ejecución

Es necesario tener instalado Flutter y contar con un dispositivo o navegador compatible.

Clonar el repositorio:

```bash
git clone https://github.com/TU_USUARIO/PracticaSQLite.git
cd PracticaSQLite
```

Instalar las dependencias:

```bash
flutter pub get
```

Ejecutar la aplicación en Linux:

```bash
flutter run -d linux
```

Para ejecutar la aplicación en Chrome, primero preparar los recursos de SQLite Web:

```bash
bash tool/preparar_web.sh
```

Después ejecutar:

```bash
flutter run -d chrome --web-port 8080
```

## Pruebas

Para verificar el proyecto:

```bash
flutter analyze
flutter test
```

La comprobación de persistencia consiste en crear tres tareas, cerrar completamente la aplicación y abrirla de nuevo para verificar que los registros permanecen almacenados.

**Resultados:** pendientes de registrar después de ejecutar las pruebas en las plataformas correspondientes.

## Estado del desarrollo

- Etapa 1: preparación y diseño.
- Etapa 2: implementación de altas, consultas y persistencia SQLite.
- Etapa 3: edición, cambio de estado y eliminación, pendiente.
- Etapa 4: compatibilidad multiplataforma y verificación final, pendiente.

La implementación está diseñada para las seis plataformas solicitadas. La compatibilidad efectiva se documentará conforme se completen las pruebas.


## Etapa 3. Operaciones restantes del CRUD

En esta etapa se agregaron las funcionalidades necesarias para completar la administración de tareas mediante SQLite.

### Edición de tareas

Se implementó la posibilidad de modificar el título de una tarea existente utilizando la instrucción `UPDATE` y su identificador. También se valida que el nuevo título no esté vacío.

### Cambio de estado

Las tareas pueden marcarse como completadas o pendientes mediante un checkbox. El estado se almacena en SQLite utilizando los valores 1 y 0.

### Eliminación de tareas

Se implementó la eliminación de registros utilizando `DELETE` y el identificador de cada tarea.

### Validaciones y manejo de errores

Se agregaron validaciones para evitar títulos vacíos y mensajes de error cuando alguna operación no se realiza correctamente.

### Pruebas

Se incorporaron pruebas automatizadas para comprobar la edición, el cambio de estado y la eliminación de tareas. Los resultados de ejecución se registrarán después de verificar la aplicación.

## Etapa 4. Compatibilidad y pruebas

Se añadió una prueba automatizada de persistencia que cierra y vuelve a abrir una base SQLite real almacenada temporalmente en disco, y comprueba que las altas, consultas, ediciones, cambios de estado y eliminaciones se conserven.

### Pruebas automatizadas

```bash
flutter pub get
flutter analyze
flutter test
```

### Ejecución nativa

```bash
flutter run -d linux
```

Para Android, utiliza el identificador mostrado por `flutter devices`:

```bash
flutter run -d ID_DISPOSITIVO
```

### Ejecución web

Los archivos `web/sqlite3.wasm` y `web/drift_worker.dart.js` deben corresponder a una versión compatible con Drift. Antes de ejecutar Chrome:

```bash
bash tool/verificar_web.sh
flutter run -d chrome --web-port 8080
```

El mismo puerto y perfil de Chrome deben conservarse para las comprobaciones de persistencia web. En la pestaña Network de DevTools, `sqlite3.wasm` debe responder con tipo `application/wasm`.

### Resultados de ejecución

Consulta `RESULTADOS_PRUEBAS.md` para el registro de P1 a P6 y de las plataformas verificadas. Los resultados deben completarse después de ejecutar las pruebas.
