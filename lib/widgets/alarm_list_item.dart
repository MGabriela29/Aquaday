import 'package:flutter/material.dart';

class AlarmListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final String alarmId;
  final Function(String alarmId, bool isActive) onToggle; // Callback para el switch

  const AlarmListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.alarmId,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xFF04246C), size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF04246C), fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
              onToggle(alarmId, value); // Llama al callback con el ID de la alarma y el nuevo valor
            },
          ),
        ],
      ),
    );
  }
}