import 'package:comprovantes/utils/string_utils.dart';
import 'package:intl/intl.dart';

class ModelosComprovantes {
  static List<ModeloComprovante> filtrarModelos(List<ModeloComprovante> todosModelos, String filtro) {
    filtro = filtro.trim();

    if (filtro.isEmpty) {
      return todosModelos;
    }
    else {
      filtro = StringUtils.removeDiacritics(filtro.toLowerCase());
      return todosModelos.where((e) => e.tituloParaBusca.contains(filtro)).toList();
    }
  }
}

class ModeloComprovante {
  int id;
  String titulo;
  late String tituloParaBusca;
  late String exemplo;
  String formato;

  ModeloComprovante(this.id, this.titulo, this.formato) {
    exemplo = _substituirVariaveis();
    tituloParaBusca = StringUtils.removeDiacritics(titulo.toLowerCase());
  }

  ModeloComprovante atualizar(String titulo, String formato) {
    this.titulo = titulo;
    this.formato = formato;
    exemplo = _substituirVariaveis();
    tituloParaBusca = StringUtils.removeDiacritics(titulo.toLowerCase());

    return this;
  }

  String _substituirVariaveis() {
    DateFormat formatoYMD = DateFormat('yyyy-MM-dd');
    String hoje = formatoYMD.format(DateTime.now());

    var mesInicial = 24253; // 202101 + 1
    String contadorOnix = (((DateTime.now().year * 12) + DateTime.now().month) - mesInicial).toString();

    return formato
      .replaceAll("{hoje}", hoje)
      .replaceAll("{contadoronix}", contadorOnix);
  }
}