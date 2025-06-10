import 'package:flutter/material.dart';

class DrinkScreen extends StatelessWidget {
  const DrinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Fondo oscuro del reloj
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 2), // Pequeño padding general para el contenedor
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Select Amount',
              style: TextStyle(
                fontSize: 10, 
                color: Colors.white70,
                decoration: TextDecoration.none,
                ),
              

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 8), // Padding horizontal para que no se pegue a los bordes
            child:Column(
              spacing: 5,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye a los extremos
              children: [
            _buildDrinkButton(context, 250),
            _buildDrinkButton(context, 500),
            _buildDrinkButton(context, 750),
            _buildDrinkButton(context, 1000), // Añadido para más opciones
            // const SizedBox(height: 2),
              ],
            ),
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     // Aquí podrías implementar una lógica para "Otros" (ej. un diálogo con un campo de texto)
            //     // Por ahora, simplemente regresa sin registrar si no se selecciona una cantidad predefinida.
            //     Navigator.pop(context);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.transparent, // Transparente para "Cancelar"
            //     foregroundColor: Colors.white70,
            //     elevation: 0,
            //   ),
            //   child: const Text('Back'),
            // ),

            Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye uniformemente
              children: [
                // Botón Drink
                Expanded( // Para que el botón ocupe el espacio disponible
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 9, 0), // Espacio entre botones más pequeño
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para cambiar los colores de los botones al presionar "Drink"
                          //   Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (_) => const DrinkScreen()),
                          // );
                        // setState(() { 
                        //   _drinkButtonColor = _primaryColor; // Drink se pone azul (color primario)
                        //   _alarmButtonColor = Colors.grey[700]!; // Alarm se pone gris
                        // });
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Bebida registrada (diseño)!')),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Usa la variable de estado para el color de fondo
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0), // Padding más pequeño
                        minimumSize: Size.zero, // Asegura que el tamaño del botón se adapte al contenido
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce el área de toque del botón
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Bordes menos redondeados para un diseño compacto
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
                    padding: const EdgeInsets.fromLTRB(9, 0, 18, 0), // Espacio entre botones más pequeño
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pop(context);
                            // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (_) => const AlarmsScreen()),
                        //   );
                        // // Lógica para cambiar los colores de los botones al presionar "Alarm"
                        // setState(() { 
                        //   _drinkButtonColor = Colors.grey[700]!; // Drink se pone gris
                        //   _alarmButtonColor = _primaryColor; // Alarm se pone azul (color primario)
                        // });
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Alarma configurada (diseño)!')),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700]!, // Usa la variable de estado para el color de fondo
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4), // Padding más pequeño
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
            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }

  Widget _buildDrinkButton(BuildContext context, int amount) {
    return SizedBox(
      width: 100,
      height: 20,
      child : Padding (
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: ElevatedButton.icon(
        onPressed: () {
          // Retorna la cantidad seleccionada a la pantalla anterior
          Navigator.pop(context, amount.toDouble());
        },
        icon: const Icon(Icons.water_drop, size: 10),
        label: Text(
          '$amount ml',
          style: const TextStyle(fontSize: 10),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F3B8F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      ),
    );
  }
}