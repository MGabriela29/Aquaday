import 'package:aquaday/services/notification_service.dart';
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:aquaday/widgets/custom_dropdown_fiel.dart';
import 'package:aquaday/widgets/alarm_time_field.dart';
import 'package:aquaday/widgets/bedtime_input.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({super.key});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final TextEditingController _alarmTimeController = TextEditingController();
  final TextEditingController _bedtimeStartTimeController = TextEditingController();
  final TextEditingController _bedtimeEndTimeController = TextEditingController();

  String? _selectedRepeatDays;
  String? _selectedDrinkQuantity;

  final List<String> _repeatDaysOptions = [
    'Every Day',
    'Weekdays',
    'Weekends',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF04246C),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF2196F3),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
        break;
    }
  }

  @override
  void dispose() {
    _alarmTimeController.dispose();
    _bedtimeStartTimeController.dispose();
    _bedtimeEndTimeController.dispose();
    super.dispose();
  }

  // *** Aquí va la función para guardar la alarma en Firebase ***
void _saveAlarm() async {
  final user = _auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Usuario no autenticado.")),
    );
    return;
  }

  if (_alarmTimeController.text.isEmpty ||
      _selectedRepeatDays == null ||
      _selectedDrinkQuantity == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Completa todos los campos.")),
    );
    return;
  }

  try {
    // Guardar en Firebase
    await _firestore.collection('alarms').add({
      'uid': user.uid,
      'alarmTime': _alarmTimeController.text,
      'repeatDays': _selectedRepeatDays,
      'drinkQuantity': _selectedDrinkQuantity,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Calcular hora para notificación
    final now = DateTime.now();
    final alarmParts = _alarmTimeController.text.split(' ');
    final timeParts = alarmParts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Convertir a 24 horas si es PM o AM
    if (alarmParts.length == 2 && alarmParts[1] == 'PM' && hour != 12) {
      hour += 12;
    }
    if (alarmParts.length == 2 && alarmParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    final alarmDateTime = DateTime(now.year, now.month, now.day, hour, minute);
    final notificationTime = alarmDateTime.isBefore(now)
        ? alarmDateTime.add(const Duration(days: 1)) // Si ya pasó, para mañana
        : alarmDateTime;

    // Programar notificación local
    await NotificationService().showScheduledNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID único
      title: 'AquaDay - ¡Hora de beber agua!',
      body: 'Toma ${_selectedDrinkQuantity!} como programaste.',
      scheduledTime: notificationTime,
    );

    // Limpiar formulario
    setState(() {
      _alarmTimeController.clear();
      _selectedRepeatDays = null;
      _selectedDrinkQuantity = null;
      _bedtimeStartTimeController.clear();
      _bedtimeEndTimeController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alarma guardada y notificación programada.")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al guardar: $e")),
    );
  }
}

  void _clearForm() {
    setState(() {
      _alarmTimeController.clear();
      _selectedRepeatDays = null;
      _selectedDrinkQuantity = null;
      _bedtimeStartTimeController.clear();
      _bedtimeEndTimeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 70.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AlarmTime',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              AlarmTimeField(
                controller: _alarmTimeController,
                onTap: () => _selectTime(_alarmTimeController),
              ),
              const SizedBox(height: 20),
              const Text(
                'RepeatDays',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomDropdownField(
                label: 'Select days',
                icon: Icons.calendar_today_outlined,
                items: _repeatDaysOptions,
                selectedValue: _selectedRepeatDays,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeatDays = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Drink quantity',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuantityButton('250 ml'),
                  _buildQuantityButton('500 ml'),
                  _buildQuantityButton('750 ml'),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton('Save', false, onPressed: _saveAlarm),
                  const SizedBox(width: 20),
                  _buildActionButton('Cancel', true, onPressed: _clearForm),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Bedtime Mode',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BedtimeInput(
                    label: 'Start',
                    controller: _bedtimeStartTimeController,
                    onTap: () => _selectTime(_bedtimeStartTimeController),
                  ),
                  const SizedBox(width: 20),
                  BedtimeInput(
                    label: 'End',
                    controller: _bedtimeEndTimeController,
                    onTap: () => _selectTime(_bedtimeEndTimeController),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Set Alarms',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // Aquí cargamos las alarmas desde Firestore dinámicamente
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('alarms')
                  .where('uid', isEqualTo: _auth.currentUser?.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No alarms set yet.");
                }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data()! as Map<String, dynamic>;
                  return _buildAlarmListItem(
                    data['alarmTime'] ?? '',
                    'Repeat: ${data['repeatDays'] ?? ''}, Quantity: ${data['drinkQuantity'] ?? ''}',
                    data['isActive'] ?? true,
                    doc.id,
                  );
                }).toList(),
              );

              },
            ),


              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 1,
        onItemTapped: onItemTapped,
      ),
    );
  }

  Widget _buildQuantityButton(String quantity) {
    bool isSelected = _selectedDrinkQuantity == quantity;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDrinkQuantity = quantity;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF2196F3) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFF04246C),
        minimumSize: const Size(90, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color:
                isSelected ? const Color(0xFF2196F3) : const Color(0xFF2196F3).withOpacity(0.5),
            width: 1.5,
          ),
        ),
        elevation: isSelected ? 4 : 2,
      ),
      child: Text(quantity, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton(String text, bool isPrimary, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF2196F3) : const Color(0xFFF0F6F9),
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF4C7B9E),
        minimumSize: const Size(120, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: Color(0xFF4C7B9E), width: 1),
        ),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

 Widget _buildAlarmListItem(String title, String subtitle, bool isActive, String alarmId) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.access_time, color: Color(0xFF04246C), size: 30),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF04246C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isActive,
          activeTrackColor: const Color.fromARGB(255, 0, 26, 255),
          inactiveThumbColor: const Color.fromARGB(255, 0, 26, 255),
          inactiveTrackColor: const Color.fromARGB(255, 135, 193, 241),
          activeColor: const Color.fromARGB(255, 135, 193, 241),
          onChanged: (value) {
            _firestore.collection('alarms').doc(alarmId).update({
              'isActive': value,
            });
          },
        ),
      ],
    ),
  );
}

}
