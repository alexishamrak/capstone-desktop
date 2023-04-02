import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:jejard_desktop/providers/aws_provider.dart';
import 'package:jejard_desktop/screens/startup_page.dart';
import 'screens/landing_page.dart';
import 'screens/analytics_screen.dart';
import 'screens/patient_info_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool _started = false;

  void start_true() {
    _started = true;
  }

  get startStatus {
    return _started;
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
                    return const AnalyticsScreen();
                  },
                ),
              ]),
          GoRoute(
            path: 'info',
            builder: (BuildContext context, GoRouterState state) {
              return const PatientInfoScreen();
            },
          ),
        ],
      ),
    ],
    initialLocation: '/',
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AWSProvider>(
      create: (_) => AWSProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'JEJARD Desktop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.green,
            backgroundColor: Colors.blue,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
