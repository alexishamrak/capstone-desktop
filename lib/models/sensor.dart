import 'dart:math';

import 'package:flutter/material.dart';

class Sensor {
  final String sensorId;
  double timestamp;
  double x;
  double y;
  double z;
  bool isConnected;
  AssetImage img;

  Sensor({
    required this.sensorId,
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
    this.img = const AssetImage(
      'assets/images/silhouette.png',
    ),
    this.isConnected = false,
  });

  //TODO: input correct threshold values
  int determineThreshold(double x, double y, double z) {
    double value = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
    print(value);
    if (value <= 1.9) {
      //limb not moving much, display red
      return 1;
    } else if (value >= 1.9 && value < 3) {
      //limb moving a good amount, display yellow
      return 2;
    } else {
      return 3; //limb moving well, display green
    }
  }
}
