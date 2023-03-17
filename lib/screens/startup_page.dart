import 'package:flutter/material.dart';
import 'package:jejard_desktop/widgets/nav_bar.dart';

import '../widgets/buttons/run_button.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  // static const routeName = '/';

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NavBar(
          color: Colors.blue,
        ),
        body: Center(
          child: RunButton(
            text: 'Start Online Application',
            buttonColor: Colors.blue,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
