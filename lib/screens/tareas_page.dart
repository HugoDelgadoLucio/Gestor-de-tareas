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

  Future<void> _ejecutar(Future<void> Function() accion) async {
    setState(() => _guardando = true);
    try {
      await accion();
      await _cargarTareas();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el cambio')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un título válido')),
      );
      return;
    }
    if (_guardando) return;
    await _ejecutar(() async {
      await widget.database.agregarTarea(titulo);
      _tituloController.clear();
    });
  }

  Future<void> _alternarCompletada(Tarea tarea, bool valor) => _ejecutar(
        () async {
          await widget.database.completarTarea(tarea.id, valor);
        },
      );

  Future<void> _editarTarea(Tarea tarea) async {
    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (context) => _DialogoEditarTarea(titulo: tarea.titulo),
    );
    if (!mounted || nuevoTitulo == null || nuevoTitulo.isEmpty || _guardando) return;
    if (nuevoTitulo == tarea.titulo) return;
    await _ejecutar(() async {
      await widget.database.editarTarea(tarea.id, nuevoTitulo);
    });
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    await _ejecutar(() async => widget.database.eliminarTarea(tarea.id));
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
                Text(
                  'Mis tareas (${_tareas.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: _cargarTareas,
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : _tareas.isEmpty
                              ? const Center(
                                  child: Text('Todavía no hay tareas guardadas'),
                                )
                              : ListView.builder(
                                  itemCount: _tareas.length,
                                  itemBuilder: (context, indice) {
                                    final tarea = _tareas[indice];
                                    return Card(
                                      child: ListTile(
                                        leading: Checkbox(
                                          value: tarea.completada,
                                          onChanged: _guardando
                                              ? null
                                              : (valor) {
                                                  if (valor != null) {
                                                    _alternarCompletada(tarea, valor);
                                                  }
                                                },
                                        ),
                                        title: Text(
                                          tarea.titulo,
                                          style: TextStyle(
                                            decoration: tarea.completada
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              tooltip: 'Editar',
                                              onPressed: _guardando
                                                  ? null
                                                  : () => _editarTarea(tarea),
                                              icon: const Icon(Icons.edit_outlined),
                                            ),
                                            IconButton(
                                              tooltip: 'Eliminar',
                                              onPressed: _guardando
                                                  ? null
                                                  : () => _eliminarTarea(tarea),
                                              icon: const Icon(Icons.delete_outline),
                                            ),
                                          ],
                                        ),
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

class _DialogoEditarTarea extends StatefulWidget {
  const _DialogoEditarTarea({required this.titulo});

  final String titulo;

  @override
  State<_DialogoEditarTarea> createState() => _DialogoEditarTareaState();
}

class _DialogoEditarTareaState extends State<_DialogoEditarTarea> {
  late final TextEditingController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController(text: widget.titulo);
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _guardar() {
    final titulo = _controlador.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título no puede estar vacío')),
      );
      return;
    }
    Navigator.of(context).pop(titulo);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar tarea'),
      content: TextField(
        controller: _controlador,
        autofocus: true,
        maxLength: 200,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(hintText: 'Título'),
        onSubmitted: (_) => _guardar(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
