import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final String quantity;
  final bool isSelected;
  final VoidCallback onPressed;

  const QuantityButton({
    super.key,
    required this.quantity,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF2196F3) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFF04246C),
        minimumSize: const Size(90, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: const Color(0xFF2196F3).withOpacity(isSelected ? 1 : 0.5), width: 1.5),
        ),
        elevation: isSelected ? 4 : 2,
      ),
      child: Text(quantity, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}