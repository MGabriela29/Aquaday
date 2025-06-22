import 'package:flutter/material.dart';

class AlarmTimeField extends StatelessWidget {
  final TextEditingController controller;
  final void Function() onTap;

  const AlarmTimeField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Container(
          width: screenWidth * 0.84,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 9,
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
    );
  }
}
