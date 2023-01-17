import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';

class PatientInfoScreen extends StatefulWidget {
  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: const NavBar(
          color: Colors.blue,
        ),
          body: Container(
            child: Text('Hello World'),
        ),
      )
    );
  }
}
