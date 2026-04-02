import 'package:flashlight_control/core/di/injection.dart';
import 'package:flashlight_control/core/services/toast_service.dart';
import 'package:flashlight_control/features/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOn = false;

  Future<void> _toggleTorch() async {
    final toast = getIt<IToastService>();

    try {
      if (_isOn) {
        await TorchLight.disableTorch();
        if (mounted) setState(() => _isOn = false);
        return;
      }

      await TorchLight.enableTorch();
      if (mounted) setState(() => _isOn = true);
    } on EnableTorchExistentUserException {
      toast.showWarning('Torch is already enabled.');
      if (mounted) setState(() => _isOn = true);
    } on DisableTorchExistentUserException {
      toast.showWarning('Torch is already disabled.');
      if (mounted) setState(() => _isOn = false);
    } on EnableTorchNotAvailableException {
      toast.showError('Torch is not available on this device.');
    } on EnableTorchException catch (_) {
      toast.showError('Could not enable torch.');
    } on DisableTorchException catch (_) {
      toast.showError('Could not disable torch.');
    } catch (_) {
      toast.showError('Torch action failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;
    final raised = colors.surface;
    final onSurface = colors.onSurface;
    final shadow = theme.shadowColor;

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: raised,
            boxShadow: [
              if (_isOn)
                BoxShadow(
                  color: onSurface.withValues(alpha: 0.6),
                  blurRadius: 52,
                  spreadRadius: 6,
                ),
              BoxShadow(
                color: shadow.withValues(alpha: 0.55),
                offset: Offset(14, 14),
                blurRadius: 28,
              ),
              BoxShadow(
                color: onSurface.withValues(alpha: 0.13),
                offset: Offset(-10, -10),
                blurRadius: 20,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggleTorch,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainerHighest,
                    border: Border.all(
                      color: _isOn
                          ? onSurface.withValues(alpha: 0.8)
                          : onSurface.withValues(alpha: 0.48),
                      width: _isOn ? 2 : 2.4,
                    ),
                    boxShadow: _isOn
                        ? [
                            BoxShadow(
                              color: onSurface.withValues(alpha: 0.7),
                              blurRadius: 36,
                              spreadRadius: 2,
                            ),
                          ]
                        : const [],
                  ),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    size: 44,
                    color: _isOn ? onSurface : onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              tooltip: 'Toggle theme',
              onPressed: () {
                final bloc = context.read<ThemeBloc>();
                final current = bloc.state.themeEventType;
                final next = current == ThemeType.darkMode
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
