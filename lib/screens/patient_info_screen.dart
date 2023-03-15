import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/dashed_separator.dart';

class PatientInfoScreen extends StatelessWidget {
  const PatientInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NavBar(
          color: Colors.blue,
        ), //NavBar
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Ramirez Santos',
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
                  children: const <Widget>[
                    Text(
                      'Age: 67',
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
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Admitted: 28/01/2023',
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
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Hand Dominance: Right',
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
                  children: const <Widget>[
                    Text(
                      'Weight: 77kg',
                      style: TextStyle(
                        fontSize: 24.0,
                        //fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ), //TextStyle
                    ), //Text
                  ], //<Widget>[]
                ), //Row
              ), //Padding

              DashedSeparator(
                color: Colors.grey.withOpacity(0.5),
              ),

              const SizedBox(height: 30.0),

              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 30.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
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
                            '\u2022 Thrombolytic (tPA)\n\u2022 Acetylsalicyclic Acid, Aspirin\n\u2022 Benazepril(Lotensin)',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ],
                      ), //Column
                    ), //Expanded

                    SizedBox(width: 50.0),

                    //Padding(
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Stroke Information:',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '\u2022 ARAT Score: 18 (Right Arm), 53 (Left Arm)\n\u2022 NIHSS Score: 12\n\u2022 Previous stroke in 2019',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ],
                      ), //Column
                    ), //Expanded
                  ], //<Widget>[]
                ), //Row
              ), //Padding

              DashedSeparator(
                color: Colors.grey.withOpacity(0.5),
              ),

              //   SizedBox(height: 25.0),

              //   SizedBox(
              //     height: 30.0,
              //     width: 800.0,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(builder: (context) => EditInfoScreen()),
              //         // );
              // },
              //       child: Text('Edit'),
              //     ),
              //   ),

              //   SizedBox(height: 25.0),

              //   DashedSeparator(
              //     color: Colors.grey.withOpacity(0.5),
              //   ),
            ], //<Widget>[]
          ), //Column
        ), //Padding
      ), //Scaffold
    ); //SafeArea
  }
}

//_PatientInfoScreenState
