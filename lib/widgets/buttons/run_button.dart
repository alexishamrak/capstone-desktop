import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';
import 'package:provider/provider.dart';

class RunButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;

  const RunButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    this.width = 200,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<AWSProvider>(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10.0),
          backgroundColor: buttonColor,
          textStyle: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.pushReplacement('/landing');
          client.connectAWS();
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
