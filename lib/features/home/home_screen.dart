import 'package:flashlight_control/core/di/injection.dart';
import 'package:flashlight_control/core/services/flashlight_control_service.dart';
import 'package:flashlight_control/core/services/toast_service.dart';
import 'package:flashlight_control/features/home/widgets/home_body.dart';
import 'package:flashlight_control/features/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FlashlightControlService _flash;

  @override
  void initState() {
    super.initState();
    _flash = FlashlightControlService(toast: getIt<IToastService>());
  }

  @override
  void dispose() {
    _flash.dispose();
    super.dispose();
  }

  Future<void> _onMainTap() async {
    final outcome = await _flash.handleMainTap();
    switch (outcome) {
      case TorchMainTapOutcome.stoppedEffects:
        HapticFeedback.lightImpact();
        break;
      case TorchMainTapOutcome.turnedOn:
        HapticFeedback.mediumImpact();
        break;
      case TorchMainTapOutcome.turnedOff:
        HapticFeedback.lightImpact();
        break;
      case TorchMainTapOutcome.unchanged:
        break;
    }
  }

  void _onStrobeTap() {
    _flash.toggleStrobe();
    HapticFeedback.selectionClick();
  }

  Future<void> _onSosTap() async {
    final outcome = await _flash.toggleSos();
    switch (outcome) {
      case TorchSosOutcome.started:
        HapticFeedback.heavyImpact();
        break;
      case TorchSosOutcome.stopped:
        HapticFeedback.lightImpact();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _flash,
          builder: (context, _) {
            return HomeBody(
              theme: theme,
              flash: _flash,
              onMainTap: _onMainTap,
              onStrobeTap: _onStrobeTap,
              onSosTap: _onSosTap,
            );
          },
        ),
      ),
      floatingActionButton:
          kDebugMode
              ? FloatingActionButton(
                tooltip: 'Toggle theme',
                onPressed: () {
                  final bloc = context.read<ThemeBloc>();
                  final current = bloc.state.themeEventType;
                  final next =
                      current == ThemeType.darkMode
                          ? ThemeType.lightMode
                          : ThemeType.darkMode;
                  bloc.add(ThemeEventChange(next));
                },
                child: const Icon(Icons.brightness_6_outlined),
              )
              : null,
    );
  }
}
