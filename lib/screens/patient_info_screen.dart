import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/dashed_separator.dart';

class PatientInfoScreen extends StatelessWidget {
  const PatientInfoScreen({super.key});

  final EdgeInsets pad = const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0);

  TextStyle adaptiveTextTitle(double w, double h) {
    if (w <= 800 && h <= 600) {
      return const TextStyle(
        letterSpacing: 1.5,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Merriweather',
      );
    } else {
      return const TextStyle(
        letterSpacing: 1.5,
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Merriweather',
      );
    }
  }

  TextStyle adaptiveTextSubtitle(double w, double h) {
    if (w <= 800 && h <= 600) {
      return const TextStyle(
        fontSize: 21.0,
        fontFamily: 'Merriweather',
        fontWeight: FontWeight.bold,
      );
    } else {
      return const TextStyle(
        // letterSpacing: 1.5,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Merriweather',
      );
    }
  }

  TextStyle adaptiveTextBody(double w, double h) {
    if (w <= 800 && h <= 600) {
      return const TextStyle(
        fontSize: 16.0,
        fontFamily: 'Merriweather',
      );
    } else {
      return const TextStyle(
        fontSize: 18.0,
        fontFamily: 'Merriweather',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // print('Width: $width');
    // print('height: $height');

    return SafeArea(
      child: Scaffold(
        appBar: const NavBar(
          color: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ramirez Santos',
                style: adaptiveTextTitle(width, height),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: pad,
                child: Text(
                  'Age: 67',
                  style: adaptiveTextSubtitle(width, height),
                ),
              ),
              Padding(
                padding: pad,
                child: Text(
                  'Admitted: 28/01/2023',
                  style: adaptiveTextSubtitle(width, height),
                ),
              ),
              Padding(
                padding: pad,
                child: Text(
                  'Hand Dominance: Right',
                  style: adaptiveTextSubtitle(width, height),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 30.0),
                child: Text(
                  'Weight: 77kg',
                  style: adaptiveTextSubtitle(width, height),
                ),
              ),
              DashedSeparator(
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 30.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Medications:',
                            style: adaptiveTextSubtitle(width, height),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                              '\u2022 Thrombolytic (tPA)\n\u2022 Acetylsalicyclic Acid, Aspirin\n\u2022 Benazepril(Lotensin)',
                              style: adaptiveTextBody(width, height)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 50.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Stroke Information:',
                            style: adaptiveTextSubtitle(width, height),
                          ),
                          // ),
                          Text(
                            '\u2022 ARAT Score: 18 (Right Arm)\n\u2022 NIHSS Score: 12\n\u2022 Previous stroke in 2019',
                            style: adaptiveTextBody(width, height),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DashedSeparator(
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
