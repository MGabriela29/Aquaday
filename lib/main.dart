// import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/smartwatch/screens/start_screen.dart';
import 'package:flutter/material.dart';
// import 'src/screens/start_screen.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'AquaDay',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor:  Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF00B4D8),
        secondary: const Color.fromARGB(255, 167, 198, 209),
        error: Colors.red,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(
          color: Color(0xFF04246C),
          fontFamily: 'Bodoni',
          fontSize: 70,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.blueGrey, 
       backgroundColor: Colors.white, 
      ),
    ),
    home: const WatchStartScreen(),//probar smartwatch
    // home: const StartScreen(),

// // // ***** INICIO DE LA CONFIGURACIÓN DE RUTAS *****
      // initialRoute: AppRoutes.initialRoute, // Establece la ruta inicial de tu aplicación
      // routes: AppRoutes.getApplicationRoutes(), // Utiliza el mapa de rutas definido en app_routes.dart


  );
}
}