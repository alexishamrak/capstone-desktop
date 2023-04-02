import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/sensor.dart';
import '../widgets/nav_bar.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

// Based on the example in: https://github.com/SyncfusionExamples/how-to-create-a-real-time-flutter-chart-in-10-minutes/blob/main/lib/main.dart

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    super.key,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late List<SensorData> chartDataLeft;
  late ChartSeriesController _chartSeriesControllerLeft;
  late List<SensorData> chartDataRight;
  late ChartSeriesController _chartSeriesControllerRight;
  late AWSProvider sensordata;

  @override
  void initState() {
    chartDataLeft = getChartDataLeft();
    chartDataRight = getChartDataRight();
    // Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  List<SensorData> getChartDataLeft() {
    return <SensorData>[
      SensorData('left', 0, 0, 0, 0),
    ];
  }

  List<SensorData> getChartDataRight() {
    return <SensorData>[
      SensorData('right', 0, 0, 0, 0),
    ];
  }

  int time = 0;
  void updateDataSource(Timer timer) {
    chartDataLeft.add(SensorData('left', time++, sensordata.findByName('LA')!.x,
        sensordata.findByName('LA')!.y, sensordata.findByName('LA')!.z));
    chartDataLeft.removeAt(0);
    _chartSeriesControllerLeft.updateDataSource(
        addedDataIndex: chartDataLeft.length - 1, removedDataIndex: 0);
    chartDataRight.add(SensorData(
        'right',
        time++,
        sensordata.findByName('RA')!.x,
        sensordata.findByName('RA')!.y,
        sensordata.findByName('RA')!.z));
    chartDataRight.removeAt(0);
    _chartSeriesControllerRight.updateDataSource(
        addedDataIndex: chartDataRight.length - 1, removedDataIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    // print('Analytics screen now');
    sensordata = Provider.of<AWSProvider>(context);
    if (sensordata.stream == false && sensordata.hasData == false) {
      Future.delayed(Duration.zero, () async {
        try {
          context.pop();
        } catch (e) {}
      });
      return const Scaffold();
    } else {
      updateChartDataLeft();
      updateChartDataRight();

      return SafeArea(
        child: Scaffold(
          appBar: const NavBar(
            color: Colors.blue,
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: SfCartesianChart(
                series: <LineSeries<SensorData, int>>[
                  LineSeries<SensorData, int>(
                    name: 'X Data',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerLeft = controller;
                    },
                    dataSource: chartDataLeft,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (SensorData sensor, _) => sensor.time,
                    yValueMapper: (SensorData sensor, _) => sensor.x,
                    width: 2,
                  ),
                  LineSeries<SensorData, int>(
                    name: 'Y Data',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerLeft = controller;
                    },
                    dataSource: chartDataLeft,
                    color: const Color.fromARGB(255, 47, 151, 186),
                    xValueMapper: (SensorData sensor, _) => sensor.time,
                    yValueMapper: (SensorData sensor, _) => sensor.y,
                    width: 2,
                  ),
                  LineSeries<SensorData, int>(
                    name: 'Z Data',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerLeft = controller;
                    },
                    dataSource: chartDataLeft,
                    color: const Color.fromARGB(255, 105, 78, 184),
                    xValueMapper: (SensorData sensor, _) => sensor.time,
                    yValueMapper: (SensorData sensor, _) => sensor.z,
                    width: 2,
                  )
                ],
                title: ChartTitle(text: 'Left Arm'),
                legend: Legend(isVisible: true),
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 1),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 2,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 2),
                  majorGridLines: const MajorGridLines(width: 1),
                  title: AxisTitle(text: 'Acceleration (m/s^2)'),
                ),
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                series: <LineSeries<SensorData, int>>[
                  LineSeries<SensorData, int>(
                    name: 'X Data',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerRight = controller;
                    },
                    dataSource: chartDataRight,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (SensorData sensor, _) => sensor.time,
                    yValueMapper: (SensorData sensor, _) => sensor.x,
                    width: 2,
                  ),
                  LineSeries<SensorData, int>(
                    name: 'Y Data',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerRight = controller;
                    },
                    dataSource: chartDataRight,
                    color: const Color.fromARGB(255, 47, 151, 186),
                    xValueMapper: (SensorData sensor, _) => sensor.time,
                    yValueMapper: (SensorData sensor, _) => sensor.y,
                    width: 2,
                  ),
                  LineSeries<SensorData, int>(
                    name: 'Z Data',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerRight = controller;
                    },
                    dataSource: chartDataRight,
                    color: const Color.fromARGB(255, 105, 78, 184),
                    xValueMapper: (SensorData sensor, _) => sensor.time,
                    yValueMapper: (SensorData sensor, _) => sensor.z,
                    width: 2,
                  ),
                ],
                title: ChartTitle(text: 'Right Arm'),
                legend: Legend(isVisible: true),
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 1),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 2,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 2),
                  majorGridLines: const MajorGridLines(width: 1),
                  title: AxisTitle(text: 'Acceleration (m/s^2)'),
                ),
              ),
            ),
          ]),
        ),
      );
    }
  }

  void updateChartDataLeft() {
    if (chartDataLeft.length < 10) {
      chartDataLeft.add(
        SensorData('left', time++, sensordata.findByName('LA')!.x,
            sensordata.findByName('LA')!.y, sensordata.findByName('LA')!.z),
      );
      if (chartDataLeft.length > 2) {
        _chartSeriesControllerLeft.updateDataSource(
            addedDataIndex: chartDataLeft.length - 1);
      }
    } else {
      chartDataLeft.add(
        SensorData('left', time++, sensordata.findByName('LA')!.x,
            sensordata.findByName('LA')!.y, sensordata.findByName('LA')!.z),
      );
      chartDataLeft.removeAt(0);
      _chartSeriesControllerLeft.updateDataSource(
          addedDataIndex: chartDataLeft.length - 1, removedDataIndex: 0);
    }
  }

  void updateChartDataRight() {
    if (chartDataRight.length < 10) {
      chartDataRight.add(
        SensorData('right', time++, sensordata.findByName('RA')!.x,
            sensordata.findByName('RA')!.y, sensordata.findByName('RA')!.z),
      );
      if (chartDataRight.length > 2) {
        _chartSeriesControllerRight.updateDataSource(
            addedDataIndex: chartDataRight.length - 1);
      }
    } else {
      chartDataRight.add(
        SensorData('right', time++, sensordata.findByName('RA')!.x,
            sensordata.findByName('RA')!.y, sensordata.findByName('RA')!.z),
      );
      chartDataRight.removeAt(0);
      _chartSeriesControllerRight.updateDataSource(
          addedDataIndex: chartDataRight.length - 1, removedDataIndex: 0);
    }
  }
}

class SensorData {
  SensorData(this.limb, this.time, this.x, this.y, this.z);
  final String limb;
  final int time;
  final double x;
  final double y;
  final double z;
}
