import 'package:flutter/material.dart';

import '../../screens/patient_info_screen.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    super.key,
    this.color = Colors.blue,
    this.size = 24.0,
  });

  final Color color;
  final double size;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      title: const Text('JEJARD Desktop'),
      centerTitle: false,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const IconButton(
              icon: Icon(
                Icons.house,
                color: Colors.white,
                semanticLabel: 'Home',
              ),
              onPressed: null, //add pressed feature later
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                semanticLabel: 'Patient Information',
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PatientInfoScreen()),
                );
              }, //add pressed feature later
            ),
          ],
        )
      ],
    );
  }
}
