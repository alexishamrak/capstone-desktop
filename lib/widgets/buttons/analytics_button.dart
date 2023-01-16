import 'package:flutter/material.dart';

import '../../screens/analytics_screen.dart';

class AnalyticsButton extends StatelessWidget {
  const AnalyticsButton({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = enabled
        ? () {
            Navigator.push(
              //check if should be pushReplacement
              context,
              MaterialPageRoute(builder: (context) => AnalyticsScreen()),
            );
          }
        : null;
    if (enabled) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),

        onPressed: onPressed, //push analytics window on screen
        /**
         * onPressed: (){
         * Navigator.push( //check if should be pushReplacement
         * context,
         * MaterialPageRoute(builder: (context) => AnalyticsScreen()),
         * );
         * }
         */
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
