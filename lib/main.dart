import 'package:flutter/material.dart';
import 'screens/landing_page.dart';

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
  //AWSProvider awsClient = AWSProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return ChangeNotifierProvider<AWSProvider>()
    //create: (_) => AWSProvider(),
    //child: MaterialApp()
    return MaterialApp(
      title: 'JEJARD Desktop',
      theme: ThemeData(
          // primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
        accentColor: Colors.green,
        backgroundColor: Colors.blue,
      )
          // useMaterial3: true,
          ),
      home: const LandingPage(title: 'JEJARD Desktop'),
      //replace line above with the following
      /** 
       * initialRoute: '/', //main page title
       * routes{
       * '/': (ctx) => LandingPage(), //landing page is main screen of app
       * AnalyticsScreen.routeName: (ctx) => AnalyticsScreen(), //route for analytics page
       * PatientInfoScreen.routeName: (ctx) => PatientInfoScreen(),
       * EditInfoScreen.routeName: (ctx) => EditInfoScreen(),
       * },
       * onGenerateRoute: (routeSettings){
       * //send arguments to analytics screen when the page is rendered; arguments inside "routeSettings"
       * return MaterialPageRoute(builder: (ctx) => AnalyticsScreen());
       * }
      */
    );
  }
}
