import 'package:aquaday/services/noti_service.dart';
import 'package:aquaday/services/notification_service.dart';
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:aquaday/widgets/custom_dropdown_fiel.dart';
import 'package:aquaday/widgets/alarm_time_field.dart';
import 'package:aquaday/widgets/bedtime_input.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:aquaday/widgets/quantity_button.dart';
import 'package:aquaday/widgets/action_button.dart';
import 'package:aquaday/widgets/alarm_list_item.dart';

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
                foregroundColor: const Color(0xFF2196F3),
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
      // Guardar en Firestore
      await _firestore.collection('alarms').add({
        'uid': user.uid,
        'alarmTime': _alarmTimeController.text,
        'repeatDays': _selectedRepeatDays,
        'drinkQuantity': _selectedDrinkQuantity,
        'isActive': true, // Por defecto, una nueva alarma está activa
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Parsear hora para notificación
      final now = DateTime.now();
      final alarmParts = _alarmTimeController.text.split(' ');
      final timeParts = alarmParts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (alarmParts.length == 2 && alarmParts[1] == 'PM' && hour != 12) {
        hour += 12;
      }
      if (alarmParts.length == 2 && alarmParts[1] == 'AM' && hour == 12) {
        hour = 0;
      }

      final alarmDateTime = DateTime(now.year, now.month, now.day, hour, minute);
      final notificationTime = alarmDateTime.isBefore(now)
          ? alarmDateTime.add(const Duration(days: 1))
          : alarmDateTime;

      debugPrint("Notificación programada para: $notificationTime");
      debugPrint("Hora de alarma: ${_alarmTimeController.text}");
      print("Días de repetición: $_selectedRepeatDays");
      print("Cantidad de bebida: $_selectedDrinkQuantity");
      print("equis $notificationTime");

      // Intentar programar notificación local
      try {
        await NotificationService().showScheduledNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: 'AquaDay - ¡Hora de beber agua!',
          body: 'Toma ${_selectedDrinkQuantity!} como programaste.',
          scheduledTime: notificationTime,
        );
      } catch (e) {
        debugPrint("❌ Error al programar la notificación: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alarma guardada, pero ocurrió un error al programar la notificación.")),
        );
      }

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
    } catch (e, st) {
      debugPrint('🧨 Error al guardar alarma: $e');
      debugPrint('STACKTRACE: $st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error inesperado al guardar: $e")),
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

  // Función para manejar el cambio de estado de la alarma en Firestore
  void _toggleAlarmActive(String alarmId, bool isActive) async {
    try {
      await _firestore.collection('alarms').doc(alarmId).update({'isActive': isActive});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarma ${isActive ? 'activada' : 'desactivada'}')),
      );
      // Aquí podrías añadir lógica para cancelar o reprogramar notificaciones
    } catch (e) {
      debugPrint('Error al actualizar el estado de la alarma: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la alarma: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 70.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AlarmTime', style: TextStyle(color: Color(0xFF4C7B9E), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AlarmTimeField(controller: _alarmTimeController, onTap: () => _selectTime(_alarmTimeController)),
              const SizedBox(height: 20),
              const Text('RepeatDays', style: TextStyle(color: Color(0xFF4C7B9E), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomDropdownField(
                label: 'Select days',
                icon: Icons.calendar_today_outlined,
                items: _repeatDaysOptions,
                selectedValue: _selectedRepeatDays,
                onChanged: (String? newValue) => setState(() => _selectedRepeatDays = newValue),
              ),
              const SizedBox(height: 20),
              const Text('Drink quantity', style: TextStyle(color: Color(0xFF4C7B9E), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  QuantityButton(
                    quantity: '250 ml',
                    isSelected: _selectedDrinkQuantity == '250 ml',
                    onPressed: () => setState(() => _selectedDrinkQuantity = '250 ml'),
                  ),
                  QuantityButton(
                    quantity: '500 ml',
                    isSelected: _selectedDrinkQuantity == '500 ml',
                    onPressed: () => setState(() => _selectedDrinkQuantity = '500 ml'),
                  ),
                  QuantityButton(
                    quantity: '750 ml',
                    isSelected: _selectedDrinkQuantity == '750 ml',
                    onPressed: () => setState(() => _selectedDrinkQuantity = '750 ml'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionButton(text: 'Save', isPrimary: true, onPressed: _saveAlarm),
                  const SizedBox(width: 20),
                  ActionButton(text: 'Cancel', isPrimary: false, onPressed: _clearForm),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  mostrarNoti(); // Asegúrate de que esta función esté definida o sea parte de noti_service
                },
                child: const Text('Probar notificación inmediata'),
              ),

              const SizedBox(height: 30),
              const Text('Bedtime Mode', style: TextStyle(color: Color(0xFF4C7B9E), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BedtimeInput(label: 'Start', controller: _bedtimeStartTimeController, onTap: () => _selectTime(_bedtimeStartTimeController)),
                  const SizedBox(width: 20),
                  BedtimeInput(label: 'End', controller: _bedtimeEndTimeController, onTap: () => _selectTime(_bedtimeEndTimeController)),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Set Alarms', style: TextStyle(color: Color(0xFF4C7B9E), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('alarms')
                    .where('uid', isEqualTo: _auth.currentUser?.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Text("No alarms set yet.");

                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data()! as Map<String, dynamic>;
                      return AlarmListItem(
                        title: data['alarmTime'] ?? '',
                        subtitle: 'Repeat: ${data['repeatDays'] ?? ''}, Quantity: ${data['drinkQuantity'] ?? ''}',
                        isActive: data['isActive'] ?? true,
                        alarmId: doc.id,
                        onToggle: _toggleAlarmActive, // Pasa la función para manejar el cambio de estado
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
}