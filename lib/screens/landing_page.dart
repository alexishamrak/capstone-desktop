import 'package:flutter/material.dart';
import 'package:jejard_desktop/widgets/sensor_widget.dart';
import '../widgets/nav_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.title});
  //static const routeName = '/'; //route name for landing page

  final String title;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NavBar(
          color: Colors.blue,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SensorWidget(
                    limbName: 'Left Arm',
                    isConnected: true,
                  ),
                  SensorWidget(
                    limbName: 'Left Leg',
                    isConnected: false,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(
                  'assets/images/silhouette.png',
                ),
                height: double.infinity,
                // Icon(Icons.person),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SensorWidget(
                      limbName: 'Right Arm',
                      isConnected: false,
                    ),
                    SensorWidget(
                      limbName: 'Right Leg',
                      isConnected: true,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
