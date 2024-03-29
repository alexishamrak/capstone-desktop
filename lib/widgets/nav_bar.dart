import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    // if (route != null) {
    //   print(route.settings.name);
    // }

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
                final GoRouterState state = GoRouterState.of(context);
                // print('The location is ${state.location}');
                if (state.location == '/' || state.location == '/landing') {
                  null;
                } else {
                  context.pushReplacement('/landing');
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                semanticLabel: 'Patient Information',
              ),
              onPressed: () {
                final GoRouterState state = GoRouterState.of(context);
                // print('The location is ${state.location}');
                if (state.location == '/' || state.location == '/info') {
                  null;
                } else {
                  context.pushReplacement('/info');
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
