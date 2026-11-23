import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/tareas_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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
}
