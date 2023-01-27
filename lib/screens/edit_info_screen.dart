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
          body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ], //<Widget>[]
                  ), //Row
                ), //Padding
              ],
            ),
          ),//Padding
      ), //Scaffold
    ); //SafeArea
  }//build
}//_PatientInfoScreenState