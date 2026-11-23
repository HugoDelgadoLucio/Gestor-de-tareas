import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart';

class TareasDatabase extends GeneratedDatabase {
  TareasDatabase()
      : super.connect(
          driftDatabase(
            name: 'gestor_tareas_local',
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.dart.js'),
            ),
          ),
        );

  TareasDatabase.conexion(super.connection) : super.connect();

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  Iterable<DatabaseSchemaEntity> get allSchemaEntities => const [];

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await customStatement('''
            CREATE TABLE IF NOT EXISTS tareas (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              titulo TEXT NOT NULL,
              completada INTEGER NOT NULL DEFAULT 0
            )
          ''');
        },
      );

  Future<List<Tarea>> listarTareas() async {
    final filas = await customSelect(
      'SELECT id, titulo, completada FROM tareas ORDER BY id DESC',
    ).get();
    return filas.map((fila) => Tarea(
      id: fila.read<int>('id'),
      titulo: fila.read<String>('titulo'),
      completada: fila.read<int>('completada') != 0,
    )).toList();
  }

  Future<int> editarTarea(int id, String titulo) {
    final valor = titulo.trim();
    if (valor.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    return customUpdate(
      'UPDATE tareas SET titulo = ? WHERE id = ?',
      variables: [Variable.withString(valor), Variable.withInt(id)],
    );
  }

  Future<int> completarTarea(int id, bool completada) {
    return customUpdate(
      'UPDATE tareas SET completada = ? WHERE id = ?',
      variables: [Variable.withInt(completada ? 1 : 0), Variable.withInt(id)],
    );
  }

  Future<int> eliminarTarea(int id) {
    return customUpdate(
      'DELETE FROM tareas WHERE id = ?',
      variables: [Variable.withInt(id)],
    );
  }

  Future<int> agregarTarea(String titulo) {
    final valor = titulo.trim();
    if (valor.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    return customInsert(
      'INSERT INTO tareas (titulo, completada) VALUES (?, 0)',
      variables: [Variable.withString(valor)],
    );
  }
}
