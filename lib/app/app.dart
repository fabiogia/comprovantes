import 'package:comprovantes/app/routes.dart';
//import 'package:comprovantes/utils/custom_material_color.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color vermelho = const Color.fromARGB(255, 186, 2, 2);

    return MaterialApp.router(
        routeInformationProvider: routes.routeInformationProvider,
        routeInformationParser: routes.routeInformationParser,
        routerDelegate: routes.routerDelegate,
        title: 'Comprovantes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: vermelho,
          appBarTheme: AppBarTheme(
              // color: vermelho,
              foregroundColor: Colors.white,
              backgroundColor: vermelho),
        ));
  }
}
