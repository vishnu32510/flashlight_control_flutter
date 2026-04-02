import 'package:flashlight_control/features/home/home_screen.dart';
import 'package:flashlight_control/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String home = '/';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: getIt<GlobalKey<NavigatorState>>(),
    initialLocation: AppRoutes.home,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
