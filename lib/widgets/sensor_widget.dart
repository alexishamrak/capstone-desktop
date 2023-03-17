import 'package:flutter/material.dart';
import 'package:jejard_desktop/widgets/buttons/analytics_button.dart';

///Contains information about the bluetooth connection, limb, and an analytics button
///

class SensorWidget extends StatefulWidget {
  SensorWidget({
    super.key,
    required this.limbName,
    this.bluetoothStatusColor = Colors.black,
    this.mobilityLevelTextColor = Colors.black,
    required this.isConnected,
  });

  String limbName; //the name of the limb for labelling purposes
  Color bluetoothStatusColor; //green is being transmitted, red is unresponsive
  Color
      mobilityLevelTextColor; //the color for the text depending on the mobility level
  bool isConnected; //determines whether the sensor is connected

  //setter for the bluetooth status color
  void setStatusColor() {
    if (isConnected) {
      bluetoothStatusColor = Colors.green;
    } else {
      bluetoothStatusColor = Colors.red;
    }
  }

  @override
  _SensorWidgetState createState() => _SensorWidgetState();
}

class _SensorWidgetState extends State<SensorWidget> {
  @override
  Widget build(BuildContext context) {
    widget.setStatusColor();
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(widget.limbName), //gets the extended variable
              Icon(
                Icons.bluetooth,
                color: widget.bluetoothStatusColor,
              ),
            ],
          ),
          AnalyticsButton(
            enabled: widget.isConnected,
            limb: widget.limbName,
          ), //if statement: if not connected, set enabled to false, else set enable to true and show analytics
          //need some sort of status determining function
        ],
      ),
    );
  }
}
