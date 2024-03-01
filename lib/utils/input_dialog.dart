import 'package:flutter/material.dart';

typedef StringCallback = void Function(String valorDigitado);

class InputDialog {
  static Future<void> show(BuildContext context, String? title, String caption,
      {required StringCallback onSuccess,
      required VoidCallback onCancel}) async {
    final TextEditingController textFieldController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: TextField(
              controller: textFieldController,
              decoration: InputDecoration(hintText: caption),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.white,
                textColor: Colors.black,
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  onSuccess.call(textFieldController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
