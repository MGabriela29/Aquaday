import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: const Color.fromARGB(255, 23, 114, 160),
      onTap: onItemTapped,

      selectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),

      items: [
        _buildBarItem(Icons.home, 'Home', 0, context),
        _buildBarItem(Icons.alarm, 'Alarms', 1, context),
        _buildBarItem(Icons.history, 'Historial', 2, context),
        _buildBarItem(Icons.person, 'Profile', 3, context),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem(
      IconData icon, String label, int index, BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      
      icon: Container(
        margin: EdgeInsets.all(9),
        // padding: const EdgeInsets.all(4.0),
        decoration: isSelected
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 29, 69, 125).withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 3),
                  )
                ],
              )
            : null,
        child: Icon(
          icon,
          size: isSelected ? 30 : 20,
          color: isSelected
              ? Theme.of(context).primaryColor
              : const Color(0xFF04246C),
        ),
      ),
      label: label,
    );
  }
}
