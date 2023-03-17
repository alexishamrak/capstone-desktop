import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';

import '../../models/sensor.dart';
import '../../screens/analytics_screen.dart';

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
                // Sensor s = context
                //     .read<AWSProvider>()
                //     .sensors
                //     .firstWhere((element) => element.sensorId == "RA");
                // var id = s.sensorId;
                // var xValue = s.x.toString();
                // var yValue = s.y.toString();
                // var zValue = s.z.toString();
                // print('$xValue $yValue $zValue');
                // context.pushNamed('analytics', queryParams: {
                //   'side': id,
                //   'x': xValue,
                //   'y': yValue,
                //   'z': zValue,
                // });
                context.pushNamed('analytics');
              } catch (e) {
                null;
              }
            } else if (limb == "Left Arm") {
              try {
                // Sensor s = context
                //     .read<AWSProvider>()
                //     .sensors
                //     .firstWhere((element) => element.sensorId == "LA");
                // var id = s.sensorId;
                // var xValue = s.x.toString();
                // var yValue = s.y.toString();
                // var zValue = s.z.toString();
                // print('$xValue $yValue $zValue');
                // context.pushNamed('analytics', queryParams: {
                //   'id': id,
                //   'x': xValue,
                //   'y': yValue,
                //   'z': zValue,
                // });
                context.pushNamed('analytics');
                // context.go('/analytics/:$id:$xValue:$yValue:$zValue');
              } catch (e) {
                null;
              }
              // Navigator.pushNamed(
              //     //check if should be pushReplacement
              //     context,
              //     '/analytics'
              //     // MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
              //     );
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
