import 'package:flutter/material.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({super.key});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  bool _hourlyAlarmEnabled = false;
  bool _customAlarmsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.black, // Fondo oscuro del reloj
        child: Padding(
      padding: EdgeInsets.fromLTRB(4, 15, 4, 0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAlarmToggle(
              'Hourly Reminders',
              _hourlyAlarmEnabled,
              (bool value) {
                setState(() {
                  _hourlyAlarmEnabled = value;
                  // Lógica para activar/desactivar la alarma por hora
                  _showSnackBar('Hourly reminders ${value ? 'enabled' : 'disabled'}');
                });
              },
            ),
            _buildAlarmToggle(
              'Custom Alarms',
              _customAlarmsEnabled,
              (bool value) {
                setState(() {
                  _customAlarmsEnabled = value;
                  // Lógica para ir a una pantalla de configuración más detallada
                  _showSnackBar('Custom alarms ${value ? 'enabled' : 'disabled'}');
                });
              },
            ),
            // const SizedBox(height: 8),
            // ElevatedButton(
            //   onPressed: () {
            //     // Aquí, idealmente, se integraría con el sistema de notificaciones del smartwatch
            //     // Por simplicidad, solo mostramos un mensaje.
            //     _showSnackBar('Notifications settings are managed via phone app.');
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFF0F3B8F),
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   child: const Text('More Settings (on Phone)'),
            // ),
            // const SizedBox(height: 5),
            Expanded(
              child: Padding(
              padding: const EdgeInsets.fromLTRB(70, 40, 70, 12), // Espacio entre botones más pequeño
            child:ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volver a la pantalla anterior
              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue!, // Usa la variable de estado para el color de fondo
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical:1), // Padding más pequeño
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 3,
                        animationDuration: const Duration(milliseconds: 300),
                        enableFeedback: true,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_rounded, size: 10, color: Colors.white), // Ícono de alarma más pequeño
                          SizedBox(width: 3),
                          Text('Back', style: TextStyle(fontSize: 8, color: Colors.white)),
                        ],
                      ),
                ),
              ),
            ),

          ],
        ),
      ),
      ),
    ),
    );
  }

  Widget _buildAlarmToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color.fromARGB(255, 116, 211, 255),
            inactiveThumbColor: const Color.fromARGB(255, 0, 21, 255),
            inactiveTrackColor: const Color.fromARGB(255, 173, 210, 228),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}