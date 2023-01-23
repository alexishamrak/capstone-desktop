import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class EditInfoScreen extends StatefulWidget {
  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: const NavBar(
            color: Colors.blue,
        ), //NavBar
          //body: 
      ), //Scaffold
    ); //SafeArea
  }//build
}//_PatientInfoScreenState