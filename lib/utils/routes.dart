import 'package:flutter/material.dart';
import 'package:aquaday/src/screens/home_screen.dart';
import 'package:aquaday/src/screens/profile.dart';
import 'package:aquaday/src/screens/alarms.dart';
import 'package:aquaday/src/screens/historial.dart';
import 'package:aquaday/src/screens/signup_screen.dart';
import 'package:aquaday/src/screens/login_screen.dart';
import 'package:aquaday/src/screens/start_screen.dart'; 

class AppRoutes {
  static const String initialRoute = '/';
  static const String signupRoute = '/signup';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String alarmsRoute = '/alarms';
  static const String historialRoute = '/historial';

  static Map<String, WidgetBuilder> getApplicationRoutes() {
    return <String, WidgetBuilder>{
      initialRoute: (BuildContext context) => const StartScreen(),
      signupRoute: (BuildContext context) => const SignupScreen(),
      loginRoute: (BuildContext context) => const LoginScreen(),
      homeRoute: (BuildContext context) => const HomeScreen(),
      profileRoute: (BuildContext context) => const ProfileScreen(),
      alarmsRoute: (BuildContext context) => const AlarmsScreen(),
      historialRoute: (BuildContext context) => const HistorialScreen(),
    };
  }
}