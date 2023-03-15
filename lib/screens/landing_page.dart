import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jejard_desktop/widgets/sensor_widget.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';
import '../widgets/nav_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.title});
  static const routeName = '/landing'; //route name for landing page

  final String title;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = Provider.of<AWSProvider>(context);
    //have a provider so the page updates
    // print('updating widget landing page');
    print(sensorData.isStreaming.toString());

    return SafeArea(
        child: (!sensorData.stream && !sensorData.hasData) ||
                sensorData.sensors.length != 2
            ? Scaffold(
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
                            isConnected: false,
                          ),
                          // SensorWidget(
                          //   limbName: 'Left Leg',
                          //   isConnected: false,
                          // ),
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
                            // SensorWidget(
                            //   limbName: 'Right Leg',
                            //   isConnected: false,
                            // ),
                          ]),
                    ),
                  ],
                ),
              )
            : Scaffold(
                appBar: const NavBar(
                  color: Colors.blue,
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Consumer<AWSProvider>(
                        builder: (context, index, value) =>
                            ChangeNotifierProvider.value(
                              value: sensorData,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SensorWidget(
                                      limbName: 'Left Arm',
                                      isConnected: sensorData
                                          .findByName("LA")!
                                          .isConnected, //CHECK THIS LATER!!! ****
                                    ),
                                    // SensorWidget(
                                    //   limbName: 'Left Leg',
                                    //   isConnected: false,
                                    // ),
                                  ],
                                ),
                              ),
                            )),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: sensorData.findByName("LA")!.img,
                        // image: AssetImage(
                        //   'assets/images/silhouette.png',
                        // ),
                        // image:
                        // sensorData
                        //     .chooseImage(), //choose image based on current threshold
                        height: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SensorWidget(
                              limbName: 'Right Arm',
                              isConnected: sensorData
                                  .findByName("RA")!
                                  .isConnected, //check later!!!!*****
                            ),
                            // SensorWidget(
                            //   limbName: 'Right Leg',
                            //   isConnected: true,
                            // ),
                          ]),
                    ),
                  ],
                ),
              ));
  }
}
