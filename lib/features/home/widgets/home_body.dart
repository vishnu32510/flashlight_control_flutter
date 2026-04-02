import 'package:flashlight_control/core/services/flashlight_control_service.dart';
import 'package:flutter/material.dart';

/// Flashlight ring (centered vertically in the upper area), strobe / SOS at bottom.
class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.theme,
    required this.flash,
    required this.onMainTap,
    required this.onStrobeTap,
    required this.onSosTap,
  });

  final ThemeData theme;
  final FlashlightControlService flash;
  final Future<void> Function() onMainTap;
  final VoidCallback onStrobeTap;
  final Future<void> Function() onSosTap;

  @override
  Widget build(BuildContext context) {
    final colors = theme.colorScheme;
    final raised = colors.surface;
    final onSurface = colors.onSurface;
    final shadow = theme.shadowColor;
    final iconOn = onSurface.withValues(alpha: 0.92);
    final iconOff = onSurface.withValues(alpha: 0.7);
    final borderOn = onSurface.withValues(alpha: 0.88);
    final borderOff = onSurface.withValues(alpha: 0.52);
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    final isOn = flash.isTorchOn;
    final strobe = flash.strobeActive;
    final sos = flash.sosActive;
    final normalMode = !strobe && !sos;

    final torch = Semantics(
      label: strobe || sos ? 'Flashlight, stop strobe or SOS' : 'Flashlight',
      button: true,
      toggled: isOn && normalMode,
      child: AnimatedScale(
        scale: isOn && normalMode ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: raised,
            boxShadow: [
              if (isOn)
                BoxShadow(
                  color: onSurface.withValues(alpha: 0.6),
                  blurRadius: 52,
                  spreadRadius: 6,
                ),
              BoxShadow(
                color: shadow.withValues(alpha: 0.55),
                offset: const Offset(14, 14),
                blurRadius: 28,
              ),
              BoxShadow(
                color: onSurface.withValues(alpha: 0.13),
                offset: const Offset(-10, -10),
                blurRadius: 20,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onMainTap,
              child: Center(
                child: AnimatedScale(
                  scale: isOn ? 1.04 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surfaceContainerHighest,
                      border: Border.all(
                        color: isOn ? borderOn : borderOff,
                        width: isOn ? 2.2 : 2.4,
                      ),
                      boxShadow:
                          isOn
                              ? [
                                BoxShadow(
                                  color: onSurface.withValues(alpha: 0.72),
                                  blurRadius: 36,
                                  spreadRadius: 2,
                                ),
                              ]
                              : const [],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) {
                          return FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.92,
                                end: 1,
                              ).animate(anim),
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          isOn
                              ? Icons.flashlight_on_rounded
                              : Icons.flashlight_off_rounded,
                          key: ValueKey<bool>(isOn),
                          size: 46,
                          color: isOn ? iconOn : iconOff,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: torch,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 16 + bottomPad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Strobe',
                    button: true,
                    toggled: strobe,
                    child: OutlinedButton.icon(
                      onPressed: onStrobeTap,
                      icon: Icon(
                        strobe
                            ? Icons.flash_on_rounded
                            : Icons.flash_on_outlined,
                        size: 20,
                      ),
                      label: Text(strobe ? 'Strobe on' : 'Strobe'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Semantics(
                    label: 'SOS distress signal',
                    button: true,
                    toggled: sos,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        elevation: sos ? 6 : 2,
                      ),
                      onPressed: onSosTap,
                      child: Text(
                        sos ? 'Stop SOS' : 'SOS',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Strobe flashes about once per second. Not for people with photosensitive epilepsy.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.55),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
