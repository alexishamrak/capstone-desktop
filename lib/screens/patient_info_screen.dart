import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/dashed_separator.dart';
import './edit_info_screen.dart';

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
        ), //NavBar
          body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'John Doe',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Merriweather',
                        ), //TextStyle
                      ), //Text
                    ], //<Widget>[]
                  ), //Row
                ), //Padding

                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Age: XX',
                        style: TextStyle(
                          fontSize: 24.0,
                          //fontWeight: FontWeight.bold,
                          fontFamily: 'Merriweather',
                        ), //TextStyle
                      ), //Text
                    ], //<Widget>[]
                  ), //Row
                ), //Padding

                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 30.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Admitted: DD/MM/YYYY',
                        style: TextStyle(
                          fontSize: 24.0,
                          //fontWeight: FontWeight.bold,
                          fontFamily: 'Merriweather',
                        ), //TextStyle
                      ), //Text
                    ], //<Widget>[]
                  ), //Row
                ), //Padding

                MySeparator(
                  color: Colors.grey.withOpacity(0.5),
                ),

                SizedBox(height: 30.0),
                
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 30.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Medications:',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            
                            SizedBox(height: 8.0),

                            Text(
                              '\u2022 Blood Thinner ABC',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                          ],
                        ),//Column
                      ),//Expanded

                      SizedBox(width: 50.0),

                      //Padding(
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Other Medical Diagnoses:',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Merriweather',
                              ),
                            ),

                            SizedBox(height: 8.0),

                            Text(
                              '\u2022 XYZ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                          ],
                        ),//Column
                      ),//Expanded
                    ], //<Widget>[]
                  ), //Row
                ), //Padding

                MySeparator(
                  color: Colors.grey.withOpacity(0.5),
                ),

                SizedBox(height: 25.0),

                SizedBox(
                  height: 30.0,
                  width: 800.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => EditInfoScreen()),
                      );
              },
                    child: Text('Edit'),
                  ),
                ),

                SizedBox(height: 25.0),

                MySeparator(
                  color: Colors.grey.withOpacity(0.5),
                ),

              ], //<Widget>[]
            ), //Column
          ), //Padding
      ), //Scaffold
    ); //SafeArea
  }//build
}//_PatientInfoScreenState
