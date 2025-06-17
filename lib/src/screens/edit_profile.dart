import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:aquaday/widgets/custom_input_field.dart';
import 'package:aquaday/widgets/custom_dropdown_fiel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _selectedGender;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          _usernameController.text = userData?['username'] ?? '';
          _phoneController.text = userData?['phone'] ?? '';
          _ageController.text= userData?['age'] ?? '';
          _heightController.text = userData?['height'] ?? '';
          _weightController.text = userData?['weight'] ?? '';
          _selectedGender = userData?['gender'];
        });
      }
    }
  }

  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'age': _ageController.text.trim(),
        'gender': _selectedGender,
        'height': _heightController.text.trim(),
        'weight': _weightController.text.trim(),
      });

      if (!mounted) return;

      // Mostrar mensaje y redirigir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'),
        backgroundColor: Color.fromARGB(255, 18, 0, 108),),
      );

      // Redirigir a perfil
      Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
    }
  }

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFF4F6FA),
      ),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        child: Card(
          shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                       side: const BorderSide(
                        color: Colors.lightBlue, width: 2),
                        ),
          elevation: 25,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical:40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                     color: Color(0xFF04246C),
                  ),
                ),
                const SizedBox(height: 40),

                CustomInputField(
                  controller: _usernameController,
                  label: 'Useername',
                  hintText: 'Enter your username',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hintText: 'Enter phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  controller: _ageController,
                  label: 'Age',
                  hintText: 'Enter your age',
                  icon: Icons.date_range,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomDropdownField(
                  label: 'Gender',
                  icon: Icons.wc_outlined,
                  items: _genderOptions,
                  selectedValue: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10), 
                CustomInputField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  hintText: 'Enter your height',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10), 
                CustomInputField(
                  controller: _weightController,
                  label: 'Weight (kg)',
                  hintText: 'Enter your weight',
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),

                ElevatedButton.icon(
                  onPressed: updateUserData,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color(0xFF04246C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 5,
                  ),
                ),
              ],
            ),
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
