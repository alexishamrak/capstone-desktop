import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';

//private class will need to identify a listener

class AnalyticsScreen extends StatefulWidget {
  AnalyticsScreen({
    super.key,
    required this.id,
    required this.x_data,
    required this.y_data,
    required this.z_data,
  });
  // static const routeName = '/analytics';
  late String id;
  late String x_data;
  late String y_data;
  late String z_data;
  late double x;
  late double y;
  late double z;

  parseXValue() {
    x = double.parse(x_data);
  }

  parseYValue() {
    y = double.parse(x_data);
  }

  parseZValue() {
    z = double.parse(x_data);
  }

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // late String sensorId;
  // late double timestamp;
  // late double x;
  // late double y;
  // late double z;

  // _AnalyticsScreenState({
  //   this.sensorId = '',
  //   this.timestamp = 0.0,
  //   this.x = 0.0,
  //   this.y = 0.0,
  //   this.z = 0.0,
  // });

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // final routeArgs =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    // sensorId = routeArgs['sensor_id'] as String;
    // timestamp = routeArgs['timestamp_s'] as double;
    // x = routeArgs['x'] as double;
    // y = routeArgs['y'] as double;
    // z = routeArgs['z'] as double;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const NavBar(
        color: Colors.blue,
      ),
    ));
  }
}
