import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalyticsButton extends StatelessWidget {
  const AnalyticsButton({
    super.key,
    required this.enabled,
    required this.limb,
  });

  final String limb;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = enabled
        ? () {
            if (limb == "Right Arm") {
              try {
                context.pushNamed('analytics');
              } catch (e) {
                null;
              }
            } else if (limb == "Left Arm") {
              try {
                context.pushNamed('analytics');
              } catch (e) {
                null;
              }
            } else {
              null;
            }
          }
        : null;
    if (enabled) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),

        onPressed: onPressed, //push analytics window on screen
        child: const Text('Analytics'),
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
        ),
        onPressed: null,
        child: const Text('Sensor Disconnected'),
      );
    }
  }
}
