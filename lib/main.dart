import 'package:flutter/material.dart';

import 'data/tareas_database.dart';
import 'screens/tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GestorTareasApp());
}

class GestorTareasApp extends StatefulWidget {
  const GestorTareasApp({super.key, this.database});

  final TareasDatabase? database;

  @override
  State<GestorTareasApp> createState() => _GestorTareasAppState();
}

class _GestorTareasAppState extends State<GestorTareasApp> {
  late final TareasDatabase _database = widget.database ?? TareasDatabase();

  @override
  void dispose() {
    if (widget.database == null) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fondo = Color(0xFF121212);
    const superficie = Color(0xFF1E1E1E);

    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fondo,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBDBDBD),
          surface: superficie,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: fondo,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: superficie,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: superficie,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: TareasPage(database: _database),
    );
  }
}
