import 'package:comprovantes/features/modelos_comprovantes/models/modelos_comprovantes.dart';
import 'package:comprovantes/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class ModeloComprovanteRepository extends ChangeNotifier {
  late Database db;
  List<ModeloComprovante> _modelos = [];
  List<ModeloComprovante> _modelosFiltrados = [];

  List<ModeloComprovante> get modelos => _modelosFiltrados;

  ModeloComprovanteRepository() {
    _initRepository();
  }

  _initRepository() async {
    db = await DB.instance.database;
    await _getModelosComprovantes();
  }

  _getModelosComprovantes() async {
    _modelos = [];
    List modelos = await db.query('modelo', orderBy: 'titulo');
    for (var modelo in modelos) {
      _modelos.add(ModeloComprovante(
        modelo['id'],
        modelo['titulo'],
        modelo['formato'],
      ));
    }

    _modelos.add(
        ModeloComprovante(0, 'Avulso. Digitar agora', '{digitar} - {hoje}'));

    _modelosFiltrados = _modelos;

    notifyListeners();
  }

  var _filtroAnterior = "";

  void filtrar(String filtro) {
    _modelosFiltrados = ModelosComprovantes.filtrarModelos(_modelos, filtro);
    _filtroAnterior = filtro;
    notifyListeners();
  }

  salvar(int id, String titulo, String formato) async {
    if (id == 0) {
      await _add(titulo, formato);
    } else {
      await _update(id, titulo, formato);
    }
    notifyListeners();
  }

  Future<void> _add(String titulo, String formato) async {
    await db.transaction((txn) async {
      await txn.insert('modelo', {'titulo': titulo, 'formato': formato});

      final incluido =
          (await txn.query('modelo', orderBy: 'id', limit: 1)).first;

      _modelos = _modelos
        ..add(ModeloComprovante(
          incluido['id'] as int,
          incluido['titulo'] as String,
          incluido['formato'] as String,
        ))
        ..sort((modelo1, modelo2) => modelo1.titulo.compareTo(modelo2.titulo));
      filtrar(_filtroAnterior);
      //notifyListeners();
    });
  }

  Future<void> _update(int id, String titulo, String formato) async {
    await db.transaction((txn) async {
      int indexEditar = _modelos.indexWhere((e) => e.id == id);
      if (indexEditar == -1) {
        return;
      }

      await txn.update('modelo', {'titulo': titulo, 'formato': formato},
          where: 'id = ?', whereArgs: [id]);

      _modelos[indexEditar] = _modelos[indexEditar].atualizar(titulo, formato);

      _modelos = _modelos
        ..sort((modelo1, modelo2) => modelo1.titulo.compareTo(modelo2.titulo));
      filtrar(_filtroAnterior);
      //notifyListeners();
    });
  }

  Future<void> delete(int id) async {
    await db.transaction((txn) async {
      await txn.delete('modelo', where: 'id = ?', whereArgs: [id]);
      notifyListeners();
    });
  }
}
