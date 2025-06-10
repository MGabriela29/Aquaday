import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:aquaday/widgets/custom_dropdown_fiel.dart';
import 'package:flutter/material.dart';


class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({super.key});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  // Estado para la hora de la alarma
  final TextEditingController _alarmTimeController = TextEditingController();
  
  // Estado para los días de repetición (Dropdown)
  String? _selectedRepeatDays;
  final List<String> _repeatDaysOptions = [ // Opciones para el dropdown de RepeatDays
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

  // Estados para las cantidades de las bebida
  String? _selectedDrinkQuantity;

  // Estados para Bedtime Mode
  final TextEditingController _bedtimeStartTimeController = TextEditingController();
  final TextEditingController _bedtimeEndTimeController = TextEditingController();

  // Función para abrir el selector de hora para AlarmTime
  Future<void> _selectAlarmTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
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
                foregroundColor: const Color(0xFF2196F3), // Color de los botones ok y cancel
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() { 
        _alarmTimeController.text = picked.format(context);
      });
    }
  }

  // Función para abrir el selector de hora para Bedtime Start
  Future<void> _selectBedtimeStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
       builder: (BuildContext context, Widget? child) {
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
        _bedtimeStartTimeController.text = picked.format(context);
      });
    }
  }

  // Función para abrir el selector de hora para Bedtime End
  Future<void> _selectBedtimeEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
       builder: (BuildContext context, Widget? child) {
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
        _bedtimeEndTimeController.text = picked.format(context);
      });
    }
  }

  // Función para manejar la navegación del BottomNavBar
  void onItemTapped(int index) {
    print('Ítem de navbar tapped desde AlarmsScreen: $index');
    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
        break;
      case 1: // Alarms
        // Ya estamos en la pantalla de alarmas
        break;
      case 2: // Historial
        Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
        break;
      case 3: // Profile
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

  @override
  Widget build(BuildContext context) {

final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
     
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 70.0), // Padding general
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alineación de los elementos
            children: [
              // Sección AlarmTime
              const Text(
                'AlarmTime',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectBedtimeStartTime(context),
                          child: AbsorbPointer(
                            child: Container(
                              width: screenWidth * 0.84, // Ancho fijo para el campo de hora
                              height: 50, // Altura fija para el campo de hora
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6), // Ajustado para ser más sutil y general
                                      blurRadius: 9,
                                      offset: const Offset(0, 2), // Ligeramente más pronunciado que el original
                                  ),
                                ],
                              ),
                              child: Center( // Centra el texto dentro del campo
                                child: TextField(
                                  controller: _bedtimeStartTimeController,
                                  readOnly: true, // Hace el campo de solo lectura
                                  textAlign: TextAlign.center, // Centra el texto
                                  style: const TextStyle(
                                    color: Color(0xFF04246C),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none, // Elimina el borde interno del TextField
                                    hintText: '12:00 p. m.',
                                    hintStyle: TextStyle(color: Color(0xFF04246C)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

              const SizedBox(height: 20),

              // Sección RepeatDays 
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
                label: 'Select days', // El hintText para el dropdown
                icon: Icons.calendar_today_outlined, // Icono de calendario
                items: _repeatDaysOptions,
                selectedValue: _selectedRepeatDays,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeatDays = newValue;
                  });
                  print('Selected Repeat Days: $_selectedRepeatDays');
                },
              ),
              const SizedBox(height: 20),

              // Sección Drink quantity
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Drink quantity',
                    style: TextStyle(
                      color: Color(0xFF4C7B9E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
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

              // Botones Save y Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('Save button pressed');
                      // Lógica para guardar la alarma
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0F6F9), // Fondo gris claro
                      foregroundColor: const Color(0xFF4C7B9E), // Texto azul
                      minimumSize: const Size(120, 45), // Tamaño mínimo del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        side: const BorderSide(color: Color(0xFF4C7B9E), width: 1), // Borde azul
                      ),
                      elevation: 2, // Sombra
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Cancel button pressed');
                      // Lógica para cancelar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3), // Fondo azul brillante
                      foregroundColor: Colors.white, // Texto blanco
                      minimumSize: const Size(120, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sección Bedtime Mode
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Bedtime Mode',
                    style: TextStyle(
                      color: Color(0xFF4C7B9E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Image.asset(
                  //   'assets/images/sleep_mode_icon.png', // Reemplaza con tu imagen del icono de cama/luna
                  //   height: 24,
                  //   width: 24,
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'start',
                          style: TextStyle(
                            color: Colors.grey, // Color más tenue para 'start'/'end'
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _selectBedtimeStartTime(context),
                          child: AbsorbPointer(
                            child: Container(
                              width: 140, // Ancho fijo para el campo de hora
                              height: 45, // Altura fija para el campo de hora
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
                              child: Center( // Centra el texto dentro del campo
                                child: TextField(
                                  controller: _bedtimeStartTimeController,
                                  readOnly: true, // Hace el campo de solo lectura
                                  textAlign: TextAlign.center, // Centra el texto
                                  style: const TextStyle(
                                    color: Color(0xFF04246C),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none, // Elimina el borde interno del TextField
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
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'end',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _selectBedtimeEndTime(context),
                          child: AbsorbPointer(
                            child: Container(
                              width: 140, // Ancho fijo
                              height: 45, // Altura fija
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
                                  controller: _bedtimeEndTimeController,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF04246C),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '05:00 a. m.',
                                    hintStyle: TextStyle(color: Color(0xFF04246C)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sección Set Alarms (Lista de alarmas existentes)
              const Text(
                'Set Alarms',
                style: TextStyle(
                  color: Color(0xFF4C7B9E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildAlarmListItem('Morning Alarm', 'Alarm set for 7:00 AM'),
              _buildAlarmListItem('Lunch Reminder', 'Alarm set for 12:30 PM'),
              _buildAlarmListItem('Evening Alarm', 'Alarm set for 6:00 PM'),

              const SizedBox(height: 30), // Espacio final antes del navbar
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 1, // 'Alarms' es el segundo ítem (índice 1)
        onItemTapped: onItemTapped,
      ),
    );
  }

  // Widget auxiliar para los botones de cantidad de bebida
  Widget _buildQuantityButton(String quantity) {
    bool isSelected = _selectedDrinkQuantity == quantity;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDrinkQuantity = quantity;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF2196F3) : Colors.white, // Azul si es seleccionado y blanco si no
        foregroundColor: isSelected ? Colors.white : const Color(0xFF04246C), // Texto blanco si es seleccionado y azul si no
        minimumSize: const Size(90, 40), // Tamaño del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
          side: BorderSide(
            color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF2196F3).withOpacity(0.5), // Borde azul
            width: 1.5,
          ),
        ),
        elevation: isSelected ? 4 : 2, // Sombra más pronunciada si seleccionado
      ),
      child: Text(quantity, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  // Widget auxiliar para los ítems de la lista de alarmas
  Widget _buildAlarmListItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), // Espacio entre ítems
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Icon(Icons.access_time, color: Color(0xFF04246C), size: 30), // Icono de reloj
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
                    color: Colors.grey, // Color gris para el subtítulo
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              print('Edit $title');
              // Lógica para editar la alarma
            },
            child: const Text(
              'edit',
              style: TextStyle(
                color: Color(0xFF2196F3), // Color azul para editar
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}