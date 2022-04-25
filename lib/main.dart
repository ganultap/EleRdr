import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Screens/LandingPage/Dashboard.dart';
import 'package:elecon_app/Screens/LandingPage/KwhReading.dart';
import 'package:elecon_app/Screens/LoadingScreen/LoadingScreen.dart';
import 'package:elecon_app/Screens/Login/LognPortal.dart';
import 'package:elecon_app/Screens/Register/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Login/Login.dart';
import 'Screens/Register/SuccessRegister.dart';
import 'package:cron/cron.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cron = Cron();

  runApp(const MyApp());
  
  try {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      await FirebaseController.calculateAppliancesConsumption();
    });
    cron.schedule(Schedule.parse('*/10 * * * *'), () async {
      await FirebaseController.calculateAppliancesBillMonthly();
    });

  } on ScheduleParseException {
    // "ScheduleParseException" is thrown if cron parsing is failed.
    await cron.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EleRdr',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purpleAccent,
        // backgroundColor: Colors.purpleAccent
      ),
      routes: {
        '/': (context) => const LoginPage(),
        'LoadingScreen': (context) => const LoadingScreen(),
        'Register': (context) => const RegistrationPage(),
        'SuccessRegister': (context) => const SuccessRegister(),
        'LoginPortal': (context) => const LoginPortal(),
        'Dashboard': (context) => const Dashboard(),
        'KwhReading': (context) => const KwhReading(),
      },
      initialRoute: 'LoadingScreen',
      // home: const LoginPage(),
    );
  }
}
