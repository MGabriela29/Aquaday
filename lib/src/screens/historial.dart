import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart for the graph

// Define a simple data model for your water intake entries
class WaterIntakeEntry {
  final int volumeMl;
  final DateTime timestamp;

  WaterIntakeEntry({required this.volumeMl, required this.timestamp});
}

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  // Dummy data for the graph (replace with actual data from your app)
  // For simplicity, let's assume daily progress and a fixed goal
  final Map<String, double> dailyProgress = {
    'Mon': 750,
    'Tue': 1100,
    'Wed': 850,
    'Thu': 1400,
    'Fri': 1000,
    'Sat': 1200,
    'Sun': 1350,
  };
  final double dailyGoal = 1250; // Example goal in ml

  // Dummy data for the water intake entries (replace with actual data)
  List<WaterIntakeEntry> waterEntries = [
    WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 6, 1, 14, 25)),
    WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 6, 1, 11, 00)),
    WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 6, 1, 8, 30)),
    WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 5, 31, 19, 15)),
    WaterIntakeEntry(volumeMl: 1000, timestamp: DateTime(2025, 5, 31, 16, 00)),
    WaterIntakeEntry(volumeMl: 500, timestamp: DateTime(2025, 5, 31, 12, 45)),
  ];

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      print('Ítem de navbar tapped desde HistorialScreen: $index');
      switch (index) {
        case 0: // Home
          Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
          break;
        case 1: // Alarms
          Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
          break;
        case 2: // Historial
          // Already on historial screen
          break;
        case 3: // Profile
          Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
          break;
      }
    }

    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Graph Section
            Container(
              padding: const EdgeInsets.all(16.0),
              width: 400,
              height: 350,
              decoration: BoxDecoration(
                color: const Color(0xFF04246C), // Matching the app bar color
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1.20, // Adjust aspect ratio as needed
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, top: 30, bottom: 2),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2), // Space between graph and list

            // List of Water Intake Entries
            ListView.builder(
              shrinkWrap: true, // Important to prevent unbounded height errors
              physics:
                  const NeverScrollableScrollPhysics(), // Disable internal scrolling
              itemCount: waterEntries.length,
              itemBuilder: (context, index) {
                final entry = waterEntries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Water glass icon (You can use your custom icon if available)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.local_drink_rounded,
                              color: Colors.blue.shade700,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.volumeMl} ml',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_formatDate(entry.timestamp)}, ${_formatTime(entry.timestamp)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // You can add an edit/delete icon here if needed
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              // Handle options for the entry
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 2,
        onItemTapped: onItemTapped,
      ),
    );
  }

  // Helper functions for date and time formatting
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // --- FL_Chart Configuration ---
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 250, // Interval for y-axis lines
        verticalInterval: 1, // Interval for x-axis lines (days)
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white24,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white24,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 250,
            getTitlesWidget: getLeftTitles,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false, // No border around the chart
      ),
      minX: 0,
      maxX: 6, // 7 days (0 to 6)
      minY: 0,
      maxY: 1500, // Max Y-axis value (adjust based on your expected max intake)
      lineBarsData: [
        // Progress Line
        LineChartBarData(
          spots: dailyProgress.entries
              .toList()
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade500,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.blue.shade700,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade200.withOpacity(0.3),
                Colors.blue.shade500.withOpacity(0.3),
              ],
            ),
          ),
        ),
        // Goal Line (Dashed)
        LineChartBarData(
          spots: [
            for (int i = 0; i <= 6; i++) FlSpot(i.toDouble(), dailyGoal)
          ],
          isCurved: false, // Straight line for goal
          color: Colors.white.withOpacity(0.7), // White for goal line
          barWidth: 2,
          dotData: const FlDotData(show: false), // No dots for goal line
          dashArray: [5, 5], // Dashed line
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // Elimina tooltipColor o getTooltipColor aquí
          // El fondo se manejará por el widget devuelto en getTooltipItems

          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              // final FlSpot spot = barSpot.spot;
              return LineTooltipItem(
                // Usa una Column o Row para organizar el texto, y envuélvela en un Container/Card
                '', // Aquí ponemos el texto dentro del Container/Card
                TextStyle(), // Estilo del texto principal del LineTooltipItem (puede estar vacío)
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: Colors.blueAccent, // Tu color de fondo deseado para el tooltip
                  //     borderRadius: BorderRadius.circular(8), // Opcional: bordes redondeados para el tooltip
                  //   ),
                  //   child: Text(
                  //     '${spot.y.toInt()} ml',
                  //     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value.toInt() % 250 == 0) {
      text = '${value.toInt()}ml';
    } else {
      text = '';
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}