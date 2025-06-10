import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label; // Este será el labelText
  final IconData icon;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label, // Este será el labelText
    required this.icon,
    required this.items,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      // *** ESTILO DEL CONTAINER (BoxDecoration) - COPIADO DE CustomInputField ***
      margin: const EdgeInsets.symmetric(vertical: 8), // Reintroducido para espaciado uniforme
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withOpacity(0.6), // Mismo color y opacidad de la sombra
            blurRadius: 9, // Mismo blurRadius
            offset: const Offset(0, 2), // Mismo offset
          ),
        ],
      ),
      child: SizedBox(
        width: 350, // Mismo ancho que CustomInputField
        height: 65, // Misma altura que CustomInputField
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            // *** ESTILO DEL INPUT DECORATION - COPIADO DE CustomInputField ***
            labelText: label, // <-- Usa 'label' como labelText aquí
            labelStyle: const TextStyle( // Estilo para el labelText
              fontWeight: FontWeight.w700,
              color: Color(0xFF04246C), // Color para el label cuando está "dentro"
            ),
            // hintText: 'Select gender', // Un hintText para el dropdown
            hintStyle: const TextStyle(color: Color(0xFF04246C)), // Mismo color para el hintText
            prefixIcon: Icon(icon, color: const Color(0xFF04246C)), // Mismo color del icono
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), // Mismo borderRadius
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5), // Mismo color y ancho del borde
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(19), // Mismo borderRadius
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2), // Mismo color y ancho del borde
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            isDense: true,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF04246C)), // Mismo color para la flecha del dropdown
          style: const TextStyle(
            color: Color(0xFF04246C), // Color del texto seleccionado (cuando ya hay un valor)
            fontSize: 16, // Tamaño de fuente del texto seleccionado
            fontWeight: FontWeight.w700, // Peso de fuente del texto seleccionado
          ),
          dropdownColor: Colors.white, // Color del fondo del menú desplegable
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              // 2. **Corrección aquí:** Asegúrate de que el Text dentro del DropdownMenuItem también tenga el estilo deseado
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF04246C), // Color de las opciones en el menú
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}