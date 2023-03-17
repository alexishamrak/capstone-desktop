import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jejard_desktop/screens/landing_page.dart';

import '../../screens/patient_info_screen.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    super.key,
    this.color = Colors.blue,
    this.size = 24.0,
  });

  final Color color;
  final double size;
  final mainRoute = "/";

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);

    if (route != null) {
      print(route.settings.name);
    }
    return AppBar(
      backgroundColor: color,
      title: const Text('JEJARD Desktop'),
      centerTitle: false,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.house,
                color: Colors.white,
                semanticLabel: 'Home',
              ),
              onPressed: () {
                // final String location = context.namedLocation(Go));
                final GoRouterState state = GoRouterState.of(context);
                print('The location is ${state.location}');

                if (state.location == '/' || state.location == '/landing') {
                  null;
                } else {
                  context.pushReplacement('/landing');
                }

                // context.pushReplacement('/landing');
                // if (ModalRoute.of(context)?.settings.name == "/" ||
                //     ModalRoute.of(context)?.settings.name == "/landing" ||
                //     ModalRoute.of(context)?.settings.name == "/analytics") {
                //   print(ModalRoute.of(context)?.settings.name);
                //   //ADD IN CODE TO ENSURE THAT THE ONLY PAGE WHERE HOME WORKS IS THE PATIENT PAGE
                //   //do nothing, don't want the page to change
                // } else {
                //   //change page to the silhouette
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             const LandingPage(title: "JEJARD Desktop")),
                //   );
                // }
              }, //add pressed feature later
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                semanticLabel: 'Patient Information',
              ),
              onPressed: () {
                final GoRouterState state = GoRouterState.of(context);
                print('The location is ${state.location}');

                if (state.location == '/' || state.location == '/info') {
                  null;
                } else {
                  context.pushReplacement('/info');
                }
                // context.go('/info');
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => PatientInfoScreen()),
                // );
              }, //add pressed feature later
            ),
          ],
        )
      ],
    );
  }
}
