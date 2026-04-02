import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'core/config/routes.dart';
import 'core/di/injection.dart';
import 'core/utils/app_constants.dart';
import 'features/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  setupDI();

  runApp(const ThemeWrapper(child: FlashlightApp()));
}

class FlashlightApp extends StatelessWidget {
  const FlashlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: getIt<GlobalKey<ScaffoldMessengerState>>(),
          theme: themeState.themeData,
          themeMode: themeState.themeMode,
          darkTheme: DarkThemeState.darkTheme.themeData,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
