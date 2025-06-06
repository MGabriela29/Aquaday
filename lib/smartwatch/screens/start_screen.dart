import 'package:aquaday/smartwatch/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WatchStartScreen extends StatelessWidget {
  const WatchStartScreen({super.key});
 @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black, // Fondo oscuro del reloj
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0), // Pequeño padding general
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            // Logo circular
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png', 
                height: 80, 
                width: 80,  
                fit: BoxFit.cover, 
              ),
            ),
            
            const SizedBox(height: 5),
            Text(
              'AquaDay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontFamily: 'Bodoni', 
                decoration: TextDecoration.none, 
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Colors.blueGrey.withOpacity(0.5),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 10), // Espacio reducido entre texto y botón

            // Botón "Drink"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WatchHomeScreen()), 
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary, 
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), 
                minimumSize: Size(0, 0), 
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), 
                ),
                elevation: 9, 
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Icon(Icons.water_drop, size: 12, color: Colors.white), 
                  SizedBox(width: 3), 
                  Text(
                    'Drink',
                    style: TextStyle(
                      fontSize: 10, 
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Espacio reducido entre botón y texto
          ],
        ),
      ),
    );
  }
}