import 'dart:io';

import 'package:comprovantes/app/home_page.dart';
import 'package:comprovantes/features/imagem_ampliada/pages/imagem_ampliada_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomePage()
      ),
      GoRoute(
        path: '/ampliada',
        builder: (BuildContext context, GoRouterState state) {
          if (state.extra != null && state.extra is File) {
            File file = state.extra as File;
            return ImagemAmpliadaPage(file: file);
          }
          return Container();
        }
        // pageBuilder: (context, state) => CustomTransitionPage<void>(
        //   key: state.pageKey,
        //   child: const SplashPage(),
        //   transitionsBuilder: (context, animation, animation2, child) {
        //     return FadeTransition(
        //       opacity: animation,
        //       child: child,
        //     );
        //   },
        // ),
      ),
    ],
  );