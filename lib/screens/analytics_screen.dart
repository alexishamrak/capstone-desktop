import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sensor.dart';
import '../widgets/nav_bar.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

//private class will need to identify a listener

class AnalyticsScreen extends StatefulWidget {
  AnalyticsScreen({
    super.key,
  });
  // static const routeName = '/analytics';

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late List<SensorData> chartDataLeft;
  late ChartSeriesController _chartSeriesControllerLeft;
  late List<SensorData> chartDataRight;
  late ChartSeriesController _chartSeriesControllerRight;
  late AWSProvider sensordata;
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
    chartDataLeft = getChartDataLeft();
    chartDataRight = getChartDataRight();
    // Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   // final routeArgs =
  //   //     ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
  //   // sensorId = routeArgs['sensor_id'] as String;
  //   // timestamp = routeArgs['timestamp_s'] as double;
  //   // x = routeArgs['x'] as double;
  //   // y = routeArgs['y'] as double;
  //   // z = routeArgs['z'] as double;
  //   super.didChangeDependencies();
  // }

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
    sensordata = Provider.of<AWSProvider>(context);
    print('X data:  ${sensordata.findByName('LA')!.x}');
    print('Chart data: ${chartDataLeft[0].x}');
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



// class _MyHomePageState extends State<MyHomePage> {
//   late List<LiveData> chartData;
//   late ChartSeriesController _chartSeriesController;

//   @override
//   void initState() {
//     chartData = getChartData();
//     Timer.periodic(const Duration(seconds: 1), updateDataSource);
//     super.initState();
//   }

//formerly build

//   int time = 19;
//   void updateDataSource(Timer timer) {
//     chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
//     chartData.removeAt(0);
//     _chartSeriesController.updateDataSource(
//         addedDataIndex: chartData.length - 1, removedDataIndex: 0);
//   }
// }