import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/tareas_database.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  testWidgets('Permite agregar, completar, editar y eliminar', (tester) async {
    final database = TareasDatabase.conexion(
      DatabaseConnection(NativeDatabase.memory()),
    );
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Estudiar SQLite');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();
    expect(find.text('Estudiar SQLite'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect((await database.listarTareas()).single.completada, isTrue);

    await tester.tap(find.byTooltip('Editar').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextField)), 'Estudiar Drift');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Estudiar Drift'), findsOneWidget);

    await tester.tap(find.byTooltip('Eliminar').first);
    await tester.pumpAndSettle();
    expect(await database.listarTareas(), isEmpty);
    expect(find.text('Estudiar Drift'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });
}
