import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
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
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 120, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userData == null
                ? const CircularProgressIndicator()
                : Card(
                    elevation: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                       side: const BorderSide(
                        color: Colors.lightBlue, width: 2),
                        ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 30, 12, 30),
                      child: Column(
                        children: [
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF04246C),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Avatar dentro de la Card
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.lightBlue, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 9,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.water_drop, size: 60, color: Colors.lightBlue),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Username dentro de la Card
                          Text(
                            userData?['username'] ?? 'Cargando...',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF04246C),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Divider(),
                          InfoRow(icon: Icons.email, label: 'Email', value: userData!['email']),
                          const Divider(
                            color: Colors.grey,
                            height: 25,
                            thickness: 1,
                            indent: 28,
                            endIndent: 20,
                          ),
                          InfoRow(icon: Icons.phone, label: 'Phone', value: userData!['phone']),
                          const Divider(
                            color: Colors.grey,
                            height: 25,
                            thickness: 1,
                            indent: 28,
                            endIndent: 20,
                          ),
                          InfoRow(icon: Icons.wc, label: 'Gender', value: userData!['gender'] ?? 'Not specified'),
                          const Divider(
                            color: Colors.grey,
                            height: 25,
                            thickness: 1,
                            indent: 28,
                            endIndent: 20,
                          ),
                          InfoRow(icon: Icons.date_range, label: 'Age', value: userData!['age'] ?? 'Not specified'),
                          const Divider(
                            color: Colors.grey,
                            height: 25,
                            thickness: 1,
                            indent: 28,
                            endIndent: 20,
                          ),
                          InfoRow(icon: Icons.height, label: 'Height (cm)', value: userData!['height'] ?? 'Not specified'),
                          const Divider(
                            color: Colors.grey,
                            height: 25,
                            thickness: 1,
                            indent: 28,
                            endIndent: 20,
                          ),
                          InfoRow(icon: Icons.monitor_weight, label: 'Weight (kg)', value: userData!['weight'] ?? 'Not specified'),
                          const SizedBox(height: 50),

                          // Botones dentro de la card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.editProfileRoute);
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final shouldLogout = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Logout'),
                                      content: const Text('If you want to logout, please confirm.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF04246C),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldLogout == true) {
                                    await FirebaseAuth.instance.signOut();
                                    if (!mounted) return;
                                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                                  }
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF04246C),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 3,
        onItemTapped: onItemTapped,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF04246C), size: 26),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}