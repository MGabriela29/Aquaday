import 'package:aquaday/src/screens/login_screen.dart';
import 'package:flutter/material.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Obtenemos una referencia a los colores del tema
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval( 
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 220, 
                  width: 220,  
                  fit: BoxFit.cover, 
                ),
              ),
              const SizedBox(height: 24),
              Text(
                    'AquaDay',
                    style: textTheme.titleLarge,
                  ),
              const SizedBox(height: 110),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800 , color: Colors.white)),
              ),
              const SizedBox(height: 80),
              Text(
                'Your daily water reminder', style: TextStyle( fontWeight: FontWeight.w800 ,color: Colors.blueGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}