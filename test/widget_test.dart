import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/tareas_database.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  testWidgets('La pantalla carga y permite agregar una tarea', (tester) async {
    final database = TareasDatabase.conexion(
      DatabaseConnection(NativeDatabase.memory()),
    );
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.pumpAndSettle();
    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Estudiar SQLite');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();
    expect(find.text('Estudiar SQLite'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
  });
}
