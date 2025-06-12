// lib/screens/auth_wrapper.dart
import 'package:aquaday/src/screens/home_screen.dart';
// import 'package:aquaday/src/screens/login_screen.dart';
import 'package:aquaday/src/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomeScreen(); // Usuario logueado
        } else {
          return const StartScreen(); // Usuario no logueado
        }
      },
    );
  }
}
