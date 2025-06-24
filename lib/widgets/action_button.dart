import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF2196F3) : const Color(0xFFF0F6F9),
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF4C7B9E),
        minimumSize: const Size(120, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isPrimary ? BorderSide.none : const BorderSide(color: Color(0xFF4C7B9E), width: 1),
        ),
        elevation: 2,
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}