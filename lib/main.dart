
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/modelos_comprovantes/repositories/modelo_comprovante_repository.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModeloComprovanteRepository()),
      ],
      child: const App()
    )
  );
}
