import 'package:flashlight_control/features/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashlight Control'),
        actions: [
          IconButton(
            tooltip: 'Toggle light / dark',
            onPressed: () {
              final bloc = context.read<ThemeBloc>();
              final current = bloc.state.themeEventType;
              final next = current == ThemeType.darkMode
                  ? ThemeType.lightMode
                  : ThemeType.darkMode;
              bloc.add(ThemeEventChange(next));
            },
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: const Center(
        child: Text('Template ready: core + DI + go_router + theme'),
      ),
    );
  }
}
