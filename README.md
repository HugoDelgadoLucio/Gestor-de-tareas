# Gestor de tareas con SQLite

## Descripción

Este proyecto corresponde a una práctica de Programación de Dispositivos Móviles, cuyo objetivo es desarrollar una aplicación Flutter que permita administrar tareas utilizando una base de datos SQLite local.

La aplicación está diseñada para trabajar en Android, iOS, Windows, Linux, macOS y web, sin necesitar un servidor externo para guardar la información.

## Tecnología de persistencia

Para almacenar las tareas se eligió SQLite, ya que permite guardar información de manera local y conservarla después de cerrar y volver a abrir la aplicación.

Se utilizará Drift junto con drift_flutter para facilitar el manejo de SQLite y mantener una misma implementación de persistencia para las distintas plataformas.

## Diseño de la base de datos

La base de datos tendrá una tabla llamada `tareas` con los siguientes campos:

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT | Identificador único de cada tarea |
| titulo | TEXT NOT NULL | Nombre de la tarea |
| completada | INTEGER NOT NULL DEFAULT 0 | Estado de la tarea: 0 pendiente y 1 completada |

Cada tarea tendrá un identificador único generado automáticamente por SQLite, lo que permitirá modificarla o eliminarla sin confundirla con otras tareas.

## Operaciones previstas

La aplicación permitirá agregar tareas nuevas, consultar las almacenadas, modificar sus títulos, cambiar su estado entre pendiente y completada, y eliminarlas.

Estas operaciones se realizarán mediante las instrucciones SQL `INSERT`, `SELECT`, `UPDATE` y `DELETE`.

## Estado inicial

En la primera etapa se preparó el proyecto Flutter, se revisó su estructura inicial y se definió la tecnología y el diseño de la base de datos. La implementación de SQLite y las operaciones sobre las tareas corresponden a las siguientes etapas.