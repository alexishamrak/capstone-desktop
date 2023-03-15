import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jejard_desktop/providers/aws_provider.dart';
import 'package:jejard_desktop/screens/startup_page.dart';
import 'package:provider/provider.dart';
import 'screens/landing_page.dart';
import 'screens/analytics_screen.dart';
import 'screens/patient_info_screen.dart';

//import 'providers/aws_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AWSProvider awsClient = AWSProvider();

  @override
  void initState() {
    super.initState();
  }

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const StartupPage();
        },
        routes: <RouteBase>[
          GoRoute(
              path: 'landing',
              builder: (BuildContext context, GoRouterState state) {
                return const LandingPage(
                  title: 'JEJARD Desktop',
                );
              },
              routes: <RouteBase>[
                GoRoute(
                  name: 'analytics',
                  path: 'analytics',
                  builder: (BuildContext context, GoRouterState state) {
                    return AnalyticsScreen(
                      id: state.queryParams['id']!,
                      x_data: state.queryParams['x']!,
                      y_data: state.queryParams['y']!,
                      z_data: state.queryParams['z']!,
                    );
                  },
                ),
              ]),
          GoRoute(
            path: 'info',
            builder: (BuildContext context, GoRouterState state) {
              return PatientInfoScreen();
            },
          ),
        ],
      ),
    ],
    initialLocation: '/',
  );

  // Route<dynamic> generateRoute(RouteSettings settings) {
  //   return MaterialPageRoute(
  //     builder: (BuildContext context) {
  //       //some custom code

  //       return _data[settings.name](context);
  //     },
  //     settings: settings,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //return ChangeNotifierProvider<AWSProvider>()
    //create: (_) => AWSProvider(),
    //child: MaterialApp()
    return ChangeNotifierProvider<AWSProvider>(
      create: (_) => AWSProvider(),
      child: MaterialApp.router(
        title: 'JEJARD Desktop',
        theme: ThemeData(
            // primarySwatch: Colors.green,
            colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.green,
          backgroundColor: Colors.blue,
        )
            // useMaterial3: true,
            ),
        routerConfig: _router,

        // home: const LandingPage(title: 'JEJARD Desktop'),
        //replace line above with the following

        // initialRoute: '/', //main page title
        // routes: {
        //   '/': (ctx) => const StartupPage(),
        //   LandingPage.routeName: (ctx) => const LandingPage(
        //         title: 'JEJARD Desktop',
        //       ), //landing page is main screen of app
        //   AnalyticsScreen.routeName: (ctx) =>
        //       const AnalyticsScreen(), //route for analytics page
        //   // PatientInfoScreen.routeName: (ctx) => PatientInfoScreen(),
        // },
        // onGenerateRoute: (settings) {
        //   //send arguments to analytics screen when the page is rendered; arguments inside "routeSettings"
        //   return MaterialPageRoute(builder: (ctx) => AnalyticsScreen());
        // },
      ),
    );
  }
}
