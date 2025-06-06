// lib/screens/home_screen.dart
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_input_op2.dart';
import 'package:flutter/material.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 

    void onItemTapped(int index) { // Renombramos de onItemTappedPlaceholder a onItemTapped
      print('Ítem de navbar tapped desde HomeScreen: $index');
      switch (index) {
        case 0: // Home
          // Ya estamos en la pantalla de Home, no hacemos nada o recargamos si es necesario.
          // Navigator.pushReplacementNamed(context, AppRoutes.homeRoute); // Puedes comentarlo si no quieres recargar la pantalla
          break;
        case 1: // Alarms
          Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
          break;
        case 2: // Historial
          Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
          break;
        case 3: // Profile
          Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
          break;
      }
    }

    final List<int> waterAmounts = [250, 500, 750, 1000, 1250, 1500, 1750, 2000];

    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 100, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your daily goal is',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 15),

            const CustomInput(
              
                    label: ' -- ml',
                    hintText: 'ml',
                    icon: Icons.edit,
                    keyboardType: TextInputType.number,
                  ),

            const SizedBox(height: 40),

            Container( 
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                'Espacio para la Gráfica / Progreso',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 50),

            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: waterAmounts.length,
                itemBuilder: (context, index) {
                  final amount = waterAmounts[index];
                  // ¡Aquí pasamos colorScheme a la función _buildWaterCard!
                  return _buildWaterCard(context, amount, Icons.local_drink, colorScheme);
                },
              ),
            ),
            const SizedBox(height: 120),

            ElevatedButton.icon(
              onPressed: () {
                print('Botón Drink presionado');
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 24,),
              label: const Text(
                'Drink',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 0,
        onItemTapped: onItemTapped,
      ),
    );
  }

  // aqui se agregan las Cards
Widget _buildWaterCard(BuildContext context, int amount, IconData icon, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        print('Card de $amount ml seleccionada');
      },
      child: Container(
        width: 100, // Ancho de cada card
        margin: const EdgeInsets.symmetric(horizontal: 8), // Espacio entre cards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),

          border: Border.all(
            color: Colors.blue.shade300, 
            width: 2, 
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 35, 85).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Sombra suave
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 15),
            Text(
              '$amount ml',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}