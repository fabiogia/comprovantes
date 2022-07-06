import 'package:comprovantes/features/modelos_comprovantes/models/modelos_comprovantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/modelo_comprovante_repository.dart';

class ModeloComprovantePage {
  static incluir(BuildContext context) {
    _exibirDialogo(context, null);
  }

  static editar(BuildContext context, ModeloComprovante modelo) {
    _exibirDialogo(context, modelo);
  }

  static bool _editarModelo = false;
  static final TextEditingController _tituloControler = TextEditingController();
  static final TextEditingController _formatoControler = TextEditingController();
  static late ModeloComprovanteRepository _modeloComprovanteRepository;

  static _exibirDialogo(BuildContext context, ModeloComprovante? modelo) {
    _editarModelo = modelo != null;

    _modeloComprovanteRepository = context.read<ModeloComprovanteRepository>();  

    if (_editarModelo) {
      _tituloControler.text = modelo!.titulo;
      _formatoControler.text = modelo.formato;
    }
    else {
      _tituloControler.text = "";
      _formatoControler.text = "";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${_editarModelo ? "Editar" : "Incluir"} modelo"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _tituloControler,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Título",
                      //icon: Icon(Icons.note_add)
                    ),
                  ),
                  TextFormField(
                    controller: _formatoControler,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Formato",
                      //icon: Icon(Icons.note_add)
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Variáveis para formato:"),
                  const Text("• {hoje} = data no formato yyyy-mm-dd"),
                  const Text("• {contadoronix} = meses desde 202101"),
              ],)
            )
          ),
          actions: [
            TextButton(
              child: Text("Cancelar", style: TextStyle(color: Colors.grey[800]),),
                onPressed: () {
                  Navigator.of(context).pop();
                }), 
            TextButton(
              child: const Text("Salvar"),
                onPressed: () async {
                  await _modeloComprovanteRepository.salvar(
                      _editarModelo ? modelo!.id : 0,
                      _tituloControler.text,
                      _formatoControler.text
                    );

                  Navigator.of(context).pop();
                }), 
          ],
        );
      });
  }

  static excluirAposConfirmacao(BuildContext context, ModeloComprovante modelo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Deseja excluir este modelo?"),
                  const SizedBox(height: 15,),
                  Text("Título: ${modelo.titulo}"),
                  Text("Formato: ${modelo.formato}"),
              ],)
            )
          ),
          actions: [
            TextButton(
              child: Text("Cancelar", style: TextStyle(color: Colors.grey[800]),),
                onPressed: () {
                  Navigator.of(context).pop();
                }), 
            TextButton(
              child: const Text("Excluir"),
                onPressed: () async {
                  await _modeloComprovanteRepository.delete(modelo.id);

                  Navigator.of(context).pop();
                }), 
          ],
        );
      });
  }
}