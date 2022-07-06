import 'dart:async';
import 'dart:io';

import 'package:comprovantes/features/modelos_comprovantes/repositories/modelo_comprovante_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';
import 'package:go_router/go_router.dart';

import '../features/modelos_comprovantes/models/modelos_comprovantes.dart';
import '../features/modelos_comprovantes/pages/modelo_comprovante_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SearchBar searchBar;

  static const miNovoModelo = 'Novo modelo de comprovante';

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Comprovantes"),
      actions: [
        searchBar.getSearchAction(context),
        PopupMenuButton<String>(
            onSelected: handleAppBarClick,
            itemBuilder: (BuildContext context) {
              return {miNovoModelo}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
      ]
    );
  }

  late ModeloComprovanteRepository _modeloComprovanteRepository;

  _HomePageState() {
    searchBar = SearchBar(
      hintText: "Filtrar",
      inBar: false,
      setState: setState,
      onSubmitted: onSearch,
      onCleared: () => onSearch(""),
      closeOnSubmit: false,
      clearOnSubmit: false,
      buildDefaultAppBar: buildAppBar
    );
  }

  onSearch(String texto) {
    setState(() {
      _modeloComprovanteRepository.filtrar(texto);
    });
  }

  void handleAppBarClick(String value) {
    switch (value) {
      case miNovoModelo:
        _adicionarModelo();
        break;
    }
  }

  late StreamSubscription _intentDataStreamSubscription;
  File? _sharedFile;
  String _imageError = "";

  void setSharedFile(List<SharedMediaFile>? value) {
    setState(() {
      var sharedFilePaths = value ?? [];
      if (sharedFilePaths.isNotEmpty) {
          try {
            _sharedFile = File(sharedFilePaths.map((f)=> f.path).first);
            _excluirCache();
          }
          catch(ex) {
            _imageError = ex.toString();
            _sharedFile = null;
          }
        }
      });
  }
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modeloComprovanteRepository = context.watch<ModeloComprovanteRepository>();
  }

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile>? value) {

        setSharedFile(value);
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile>? value) {
      setSharedFile(value);
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  final headerModelos = const Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 2), 
    child: Text("Modelos", 
      style: TextStyle(fontWeight: FontWeight.bold),
    ));

  @override
  Widget build(BuildContext context) {
    const contaItem0DaImagem = 1;

    ToastContext().init(context);

    var modelos = _modeloComprovanteRepository.modelos;

    return Scaffold(
      appBar: searchBar.build(context),
            body: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (_sharedFile != null)
                        ? GestureDetector(
                            onTap: () => _exibirImagemAmpliada(context),
                            child: 
                                Hero(
                                  tag: 'image1',
                                  child: Center(child: 
                                    Image.file(
                                      _sharedFile!,
                                      height: MediaQuery.of(context).size.height / 3,
                                    ),
                                  ),
                                ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _imageError == ""
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image, color: Theme.of(context).primaryColor),
                                    const Text(" Sem Imagem")
                                  ],
                                )
                              : Text(_imageError, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                          ),
                      headerModelos
                    ]);
                }
                else {
                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    // key: const ValueKey(0),

                    // The start action pane is the one at the left or the top side.
                    endActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: null, // DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (BuildContext context) => {
                            _confirmarExclusao(context, modelos[index - 1])
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Excluir',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) => {
                            ModeloComprovantePage.editar(context, modelos[index - 1])
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Editar',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(modelos[index - 1].titulo),
                      subtitle: Text(modelos[index - 1].exemplo),
                      onTap: () => _copiarExemplo(modelos[index - 1]),
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    )
                  );
                }
              }, 
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
              itemCount: modelos.length + contaItem0DaImagem),
              //)
          // ], ), ),
    );
  }

  _adicionarModelo() {
    ModeloComprovantePage.incluir(context);
  }

  _copiarExemplo(ModeloComprovante modelo) {
    ArgumentError.checkNotNull(modelo, "modelo");

    if (_sharedFile != null) {
      Share.shareFiles([ _sharedFile!.path ], 
      subject: modelo.exemplo,
      text: modelo.exemplo);
    }
    else {
      Toast.show(
        "Sem imagem para compartilhar",
        duration: Toast.lengthLong,
        gravity:  Toast.bottom);
    }
  }

  _exibirImagemAmpliada(BuildContext context) {
    context.push('/ampliada', extra: _sharedFile);

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => ImagemAmpliadaPage(file: _sharedFile!),
    //   ), 
    // );
  }
  
  _confirmarExclusao(BuildContext context, ModeloComprovante modelo) {
    ArgumentError.checkNotNull(modelo, "modelo");
    ModeloComprovantePage.excluirAposConfirmacao(context, modelo);
  }

  _excluirCache() {
    String sharedFilePath = _sharedFile!.path;
    String nomeDiretorio = sharedFilePath.substring(0, sharedFilePath.lastIndexOf('/'));
    Directory dir = Directory(nomeDiretorio);
    
    dir.list(recursive: false).forEach((f) {
      if (f.path != sharedFilePath) {
        f.delete();
      }
    });

    
  }
}
