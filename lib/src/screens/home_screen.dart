import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_input_op2.dart';
import 'package:flutter/material.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:percent_indicator/percent_indicator.dart'; // ✅ Importamos la librería

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void onItemTapped(int index) {
      print('Ítem de navbar tapped desde HomeScreen: $index');
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
          break;
        case 2:
          Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
          break;
        case 3:
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

            // ✅ Reemplazamos el contenedor con la gráfica
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 15.0,
              percent: 0.6, // 60% de progreso (puedes ajustar dinámicamente)
              center: const Text(
                "60%",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.blue.shade600,
              backgroundColor: Colors.blue.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),

            const SizedBox(height: 50),

            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: waterAmounts.length,
                itemBuilder: (context, index) {
                  final amount = waterAmounts[index];
                  return _buildWaterCard(context, amount, Icons.local_drink, colorScheme);
                },
              ),
            ),
            const SizedBox(height: 120),

            ElevatedButton.icon(
              onPressed: () {
                print('Botón Drink presionado');
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
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

  Widget _buildWaterCard(BuildContext context, int amount, IconData icon, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        print('Card de $amount ml seleccionada');
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
              offset: const Offset(0, 3),
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
