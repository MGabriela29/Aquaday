import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:aquaday/widgets/custom_dropdown_fiel.dart';
import 'package:flutter/material.dart';
import 'package:aquaday/widgets/custom_input_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables de estado para los valores de los campos
  String? _selectedGender; // Variable para almacenar el género seleccionado

  // Lista de opciones para el género
  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  void onItemTapped(int index) {
    print('Ítem de navbar tapped desde ProfileScreen: $index');
    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
        break;
      case 1: // Alarms
        Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
        break;
      case 2: // Historial
        Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
        break;
      case 3: // Profile
        // Ya estamos en la pantalla de perfil, no hacemos nada o refrescamos si es necesario.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),

              // Avatar y "My Info"
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  // child: Image(
                  //   image: AssetImage('assets/images/profile.png'),
                  //   fit: BoxFit.contain,
                  // ),
                  child: Icon(Icons.water_drop, size: 60, color: Color(0xFF4C7B9E)),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'My Info',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF04246C), // Usar el color del título grande
                ),
              ),
              const SizedBox(height: 30),

              CustomInputField(
                label: 'Enter Name',
                hintText: 'enter', 
                icon: Icons.person,
                // onChanged: (value) {
                //   // _name = value; // Si quieres guardar el nombre
                // },
              ),
              const SizedBox(height: 20),

              CustomInputField(
                label: 'Enter Age',
                hintText: 'enter',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                // onChanged: (value) {
                //   // _age = int.tryParse(value); // Si quieres guardar la edad
                // },
              ),
              const SizedBox(height: 20),

              // Campo de selección para Género
              CustomDropdownField(
                label: 'Selected Gender',
                icon: Icons.wc_outlined,
                items: _genderOptions,
                selectedValue: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                  print('Selected Gender: $_selectedGender');
                },
              ),
              const SizedBox(height: 20),

              CustomInputField(
                label: 'Enter Height (cm)',
                hintText: 'enter',
                icon: Icons.straighten_rounded,
                keyboardType: TextInputType.number,
                // onChanged: (value) {
                //   // _height = double.tryParse(value); // Si quieres guardar la altura
                // },
              ),
              const SizedBox(height: 20),

              CustomInputField(
                label: 'Enter Weight (kg)',
                hintText: 'enter',
                icon: Icons.monitor_weight_rounded,
                keyboardType: TextInputType.number,
                // onChanged: (value) {
                //   // _weight = double.tryParse(value); // Si quieres guardar el peso
                // },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 3,
        onItemTapped: onItemTapped,
      ),
    );
  }
}