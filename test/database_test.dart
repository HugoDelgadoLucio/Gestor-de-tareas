import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/tareas_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Operaciones CRUD', () {
    late TareasDatabase database;

    setUp(() {
      database = TareasDatabase.conexion(
        DatabaseConnection(NativeDatabase.memory()),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('Guarda y consulta tareas con identificadores diferentes', () async {
      await database.agregarTarea('Primera');
      await database.agregarTarea('Segunda');
      final tareas = await database.listarTareas();
      expect(tareas.length, 2);
      expect(tareas.first.titulo, 'Segunda');
      expect(tareas.first.id, isNot(tareas.last.id));
      expect(tareas.every((tarea) => !tarea.completada), isTrue);
    });

    test('Rechaza tareas vacías o formadas por espacios', () async {
      expect(() => database.agregarTarea('   '), throwsArgumentError);
      expect(await database.listarTareas(), isEmpty);
    });

    test('Edita el título y rechaza cambios vacíos', () async {
      final id = await database.agregarTarea('Anterior');
      expect(await database.editarTarea(id, '  Nuevo  '), 1);
      expect((await database.listarTareas()).single.titulo, 'Nuevo');
      expect(() => database.editarTarea(id, '   '), throwsArgumentError);
      expect((await database.listarTareas()).single.titulo, 'Nuevo');
    });

    test('Actualiza el estado entre pendiente y completada', () async {
      final id = await database.agregarTarea('Tarea');
      expect(await database.completarTarea(id, true), 1);
      expect((await database.listarTareas()).single.completada, isTrue);
      expect(await database.completarTarea(id, false), 1);
      expect((await database.listarTareas()).single.completada, isFalse);
    });

    test('Elimina por identificador sin afectar a otras tareas', () async {
      final id = await database.agregarTarea('Eliminar');
      final otro = await database.agregarTarea('Conservar');
      expect(await database.eliminarTarea(id), 1);
      final tareas = await database.listarTareas();
      expect(tareas.length, 1);
      expect(tareas.single.id, otro);
      expect(tareas.single.titulo, 'Conservar');
    });
  });

  test(
    'Conserva altas, edición, estado y bajas después de reabrir SQLite',
    () async {
      final directorio = await Directory.systemTemp.createTemp(
        'gestor_tareas_test_',
      );
      final archivo = File('${directorio.path}/tareas.sqlite');
      TareasDatabase? persistente;

      try {
        persistente = TareasDatabase.conexion(
          DatabaseConnection(NativeDatabase(archivo)),
        );
        final primera = await persistente.agregarTarea('Primera tarea');
        final segunda = await persistente.agregarTarea('Segunda tarea');
        final tercera = await persistente.agregarTarea('Tercera tarea');
        await persistente.close();
        persistente = null;

        persistente = TareasDatabase.conexion(
          DatabaseConnection(NativeDatabase(archivo)),
        );
        expect((await persistente.listarTareas()).length, 3);
        await persistente.editarTarea(primera, 'Primera modificada');
        await persistente.completarTarea(segunda, true);
        await persistente.eliminarTarea(tercera);
        await persistente.close();
        persistente = null;

        persistente = TareasDatabase.conexion(
          DatabaseConnection(NativeDatabase(archivo)),
        );
        final tareas = await persistente.listarTareas();
        expect(tareas.length, 2);
        expect(
          tareas.any(
            (t) => t.id == primera && t.titulo == 'Primera modificada',
          ),
          isTrue,
        );
        expect(tareas.any((t) => t.id == segunda && t.completada), isTrue);
        expect(tareas.any((t) => t.id == tercera), isFalse);
      } finally {
        await persistente?.close();
        await directorio.delete(recursive: true);
      }
    },
  );
}
