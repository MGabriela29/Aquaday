import 'package:flutter/material.dart';

class BedtimeInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function() onTap;

  const BedtimeInput({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toLowerCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              child: Container(
                width: 140,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC7E0F0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF04246C),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '12:00 p. m.',
                      hintStyle: TextStyle(color: Color(0xFF04246C)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
