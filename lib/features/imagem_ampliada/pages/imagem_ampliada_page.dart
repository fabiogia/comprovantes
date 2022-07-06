import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';

class ImagemAmpliadaPage extends StatefulWidget {
  const ImagemAmpliadaPage({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<ImagemAmpliadaPage> createState() => _ImagemAmpliadaPageState();
}

class _ImagemAmpliadaPageState extends State<ImagemAmpliadaPage> {
  final PhotoViewController controller = PhotoViewController(initialScale: 1);

  // String scale = "?";

  // @override
  // void initState() {
  //   super.initState();
  //   controller.outputStateStream.listen((event) {
  //     setState(() {
  //       scale = event.scale == null ? "null" : event.scale!.toStringAsFixed(4);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comprovantes")),
      body: Hero(
        tag: 'image1',
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained * 0.95,
          controller: controller,
          //initialScale: 1.0,
          imageProvider: FileImage(widget.file))),
    );
  }
}