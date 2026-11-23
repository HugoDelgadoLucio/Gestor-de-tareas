import 'package:flutter/material.dart';

import '../data/tareas_database.dart';
import '../models/tarea.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({super.key, required this.database});

  final TareasDatabase database;

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final _tituloController = TextEditingController();
  List<Tarea> _tareas = [];
  bool _cargando = true;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    try {
      final tareas = await widget.database.listarTareas();
      if (!mounted) return;
      setState(() {
        _tareas = tareas;
        _cargando = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudo abrir la base de datos local';
      });
    }
  }

  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty || _guardando) return;
    setState(() => _guardando = true);
    try {
      await widget.database.agregarTarea(titulo);
      if (!mounted) return;
      _tituloController.clear();
      await _cargarTareas();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la tarea')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _tituloController,
                  maxLength: 200,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _agregarTarea(),
                  decoration: const InputDecoration(
                    hintText: 'Escribe una tarea',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _guardando ? null : _agregarTarea,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar tarea'),
                ),
                const SizedBox(height: 24),
                Text('Mis tareas (${_tareas.length})',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Expanded(
                  child: _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    onPressed: _cargarTareas,
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : _tareas.isEmpty
                              ? const Center(child: Text('Todavía no hay tareas guardadas'))
                              : ListView.builder(
                                  itemCount: _tareas.length,
                                  itemBuilder: (context, index) {
                                    final tarea = _tareas[index];
                                    return Card(
                                      child: ListTile(
                                        title: Text(tarea.titulo),
                                        subtitle: Text('ID: ${tarea.id} · ${tarea.completada ? 'Completada' : 'Pendiente'}'),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
