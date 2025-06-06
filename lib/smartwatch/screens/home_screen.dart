import 'package:flutter/material.dart';
import 'dart:math' as math; // Necesario para el CustomPainter del círculo de progreso

class WatchHomeScreen extends StatefulWidget {
  const WatchHomeScreen({super.key});

  @override
  State<WatchHomeScreen> createState() => _WatchHomeScreenState();
}

class _WatchHomeScreenState extends State<WatchHomeScreen> {
  // Variables de estado para los colores de los botones
  // Se inicializan con valores por defecto seguros que luego serán actualizados en didChangeDependencies.
  Color _drinkButtonColor = Colors.blue; 
  Color _alarmButtonColor = Colors.grey[700]!; 
  
  // Color primario del tema, se inicializará en didChangeDependencies.
  late Color _primaryColor; 
  
  @override
  void initState() {
    super.initState();
    // initState es el lugar para inicializaciones que no dependen del BuildContext.
    // Para cosas que sí dependen del BuildContext, como Theme.of(context), usamos didChangeDependencies.
  }

  @override
  void didChangeDependencies() {
    // Este método se llama después de initState y cuando las dependencias (como el Theme) cambian.
    // Aquí Theme.of(context) ya está disponible de forma segura.
    super.didChangeDependencies();
    _primaryColor = Theme.of(context).colorScheme.primary;

    // Una vez que _primaryColor está disponible, inicializamos los colores de los botones.
    // Esto asegura que los colores iniciales correspondan al tema.
    _drinkButtonColor = _primaryColor; 
    _alarmButtonColor = Colors.grey[700]!;
  }

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo (puedes hacer que estos datos vengan de un estado real de tu app)
    final int percentage = 60; // Valor del porcentaje para el círculo
    final int mlDrank = 1080; // Mililitros consumidos
    final String time = 'Friday 11:00 a.m.'; // Hora y día

    return Container(
      color: Colors.black, // Fondo oscuro del reloj
      child: Padding(
        padding: const EdgeInsets.all(5.0), // Pequeño padding general para el contenedor
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye el espacio verticalmente de manera uniforme
          children: [
            // Primer elemento: Círculo de progreso y porcentaje
            Expanded( // Permite que el círculo ocupe el espacio disponible
              child: Center( // Centra el círculo en el espacio disponible
                child: SizedBox( // Usamos SizedBox para limitar el tamaño del círculo
                  width: 90, // Tamaño fijo para el círculo (ajusta según necesites)
                  height: 90, // Debe ser igual al ancho para un círculo perfecto
                  child: CustomPaint(
                    painter: ProgressPainter(
                      percentage: percentage,
                      backgroundColor: Colors.grey[800]!, // Color del fondo del círculo (gris oscuro)
                      progressColor: _primaryColor, // Color del progreso (el azul del tema)
                      strokeWidth: 6.0, // Ancho de la línea del círculo, más delgado
                    ),
                    child: Center(
                      child: Text(
                        '$percentage %', // Muestra el porcentaje
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Tamaño del porcentaje más pequeño
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none, // Asegura que no tenga subrayado por defecto
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10), // Espacio entre el círculo y los textos de abajo

            // Segundo elemento: Mililitros y hora (en una fila), con padding para los bordes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding horizontal para que no se pegue a los bordes
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye a los extremos
                children: [
                  Text(
                    '$mlDrank ml', // Muestra los mililitros consumidos
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11, // Tamaño de fuente más pequeño
                      fontWeight: FontWeight.w600, // Un poco más ancho/negrita
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    time, // Muestra la hora y día
                    style: TextStyle(
                      color: Colors.grey[400], // Un gris más claro para la hora
                      fontSize: 9, // Tamaño de fuente más pequeño
                      fontWeight: FontWeight.w600, // Un poco más ancho/negrita
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10), // Espacio entre los textos y los botones

            // Tercer elemento: Botones "Drink" y "Alarm" (en una fila)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuye uniformemente
              children: [
                // Botón Drink
                Expanded( // Para que el botón ocupe el espacio disponible
                  child: Padding(
                    padding: const EdgeInsets.only(right: 3.0), // Espacio entre botones más pequeño
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para cambiar los colores de los botones al presionar "Drink"
                        setState(() { 
                          _drinkButtonColor = _primaryColor; // Drink se pone azul (color primario)
                          _alarmButtonColor = Colors.grey[700]!; // Alarm se pone gris
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bebida registrada (diseño)!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _drinkButtonColor, // Usa la variable de estado para el color de fondo
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), // Padding más pequeño
                        minimumSize: Size.zero, // Asegura que el tamaño del botón se adapte al contenido
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce el área de toque del botón
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Bordes menos redondeados para un diseño compacto
                        elevation: 3, // Sombra más pequeña
                        animationDuration: const Duration(milliseconds: 300), // Duración de la animación del cambio de color
                        enableFeedback: true, // Habilitar feedback háptico/sonido al presionar
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, size: 10, color: Colors.white), // Ícono de gota de agua más pequeño
                          SizedBox(width: 3), // Espacio pequeño entre el ícono y el texto
                          Text('Drink', style: TextStyle(fontSize: 8, color: Colors.white)), // Texto más pequeño
                        ],
                      ),
                    ),
                  ),
                ),
                // Botón Alarm
                Expanded( // Para que el botón ocupe el espacio disponible
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3.0), // Espacio entre botones más pequeño
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para cambiar los colores de los botones al presionar "Alarm"
                        setState(() { 
                          _drinkButtonColor = Colors.grey[700]!; // Drink se pone gris
                          _alarmButtonColor = _primaryColor; // Alarm se pone azul (color primario)
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alarma configurada (diseño)!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _alarmButtonColor, // Usa la variable de estado para el color de fondo
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), // Padding más pequeño
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 3,
                        animationDuration: const Duration(milliseconds: 300),
                        enableFeedback: true,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_active_outlined, size: 10, color: Colors.white), // Ícono de alarma más pequeño
                          SizedBox(width: 3),
                          Text('Alarm', style: TextStyle(fontSize: 8, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// CustomPainter para dibujar el círculo de progreso
class ProgressPainter extends CustomPainter {
  final int percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth; // Propiedad para controlar el grosor de la línea

  ProgressPainter({
    required this.percentage,
    required this.backgroundColor,
    required this.progressColor,
    this.strokeWidth = 8.0, // Valor por defecto, pero se puede sobrescribir
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo del círculo
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth; 

    // Progreso
    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round // Extremos redondeados de la línea de progreso
      ..strokeWidth = strokeWidth;

    final Offset center = Offset(size.width / 2, size.height / 2);
    // Calcular el radio, restando la mitad del ancho de la línea para que el círculo quepa dentro del espacio
    final double radius = math.min(size.width / 2, size.height / 2) - backgroundPaint.strokeWidth / 2;

    // Dibujar el fondo del círculo completo
    canvas.drawCircle(center, radius, backgroundPaint);

    // Dibujar el arco de progreso
    final double sweepAngle = 2 * math.pi * (percentage / 100); // Calcular el ángulo en radianes basado en el porcentaje (0 a 100%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Empezar desde la parte superior del círculo (posición de las 12 en punto)
      sweepAngle,
      false, // No unir el centro del círculo con los extremos del arco (solo dibuja el arco)
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Solo repintar si el porcentaje, el ancho de la línea o el color de progreso han cambiado,
    // para optimizar el rendimiento.
    return (oldDelegate as ProgressPainter).percentage != percentage ||
           (oldDelegate).strokeWidth != strokeWidth ||
           (oldDelegate).progressColor != progressColor;
  }
}