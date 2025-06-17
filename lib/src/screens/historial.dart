import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  List<WaterIntakeEntry> waterEntries = [];
  final double dailyGoal = 1250;
  Map<String, double> dailyProgress = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

@override
  void initState() {
    super.initState();
    fetchWaterEntriesFromRealtimeDB();

  }


  Future<void> fetchWaterEntriesFromRealtimeDB() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

  final dbRef = FirebaseDatabase.instance.ref('users/${user.uid}/historial');
  final snapshot = await dbRef.get();

  Map<String, double> progressMap = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  List<WaterIntakeEntry> entries = [];

  if (snapshot.exists) {
    final data = snapshot.value as Map<dynamic, dynamic>;

    data.forEach((dateStr, volume) {
      final dateParts = dateStr.split('-');
      if (dateParts.length == 3) {
        final date = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        );

final weekday = _getWeekdayLabel(date.weekday);

        final double parsedVolume = (volume is int || volume is double)
            ? (volume as num).toDouble()
            : 0;

        progressMap[weekday] = (progressMap[weekday] ?? 0) + parsedVolume;

        entries.add(WaterIntakeEntry(
          volumeMl: parsedVolume.toInt(),
          timestamp: date,
        ));
      }
    });
  }

  setState(() {
    waterEntries = entries;
    dailyProgress = progressMap;
  });
}



String _getWeekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }




  // final double dailyGoal = 1250;

  // List<WaterIntakeEntry> waterEntries = [
  //   WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 6, 1, 14, 25)),
  //   WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 6, 1, 11, 00)),
  //   WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 6, 1, 8, 30)),
  //   WaterIntakeEntry(volumeMl: 1250, timestamp: DateTime(2025, 5, 31, 19, 15)),
  //   WaterIntakeEntry(volumeMl: 1000, timestamp: DateTime(2025, 5, 31, 16, 00)),
  //   WaterIntakeEntry(volumeMl: 500, timestamp: DateTime(2025, 5, 31, 12, 45)),
  // ];

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
          break;
        case 1:
          Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
          break;
        case 2:
          break;
        case 3:
          Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
          break;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: 400,
              height: 350,
              decoration: BoxDecoration(
                color: const Color(0xFF04246C),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: AspectRatio(
                aspectRatio: 1.20,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, top: 30, bottom: 2),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: waterEntries.length,
              itemBuilder: (context, index) {
                final entry = waterEntries[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
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
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
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

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  LineChartData mainData() {
    final List<String> weekOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 250, verticalInterval: 1),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: getBottomTitles)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 250, getTitlesWidget: getLeftTitles, reservedSize: 42)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 1500,
      lineBarsData: [
        LineChartBarData(
          spots: weekOrder.asMap().entries.map((entry) {
            int index = entry.key;
            String day = entry.value;
            double value = dailyProgress[day] ?? 0;
            return FlSpot(index.toDouble(), value);
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade500]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: Colors.blue.shade700);
          }),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.blue.shade200.withOpacity(0.3), Colors.blue.shade500.withOpacity(0.3)],
            ),
          ),
        ),
        LineChartBarData(
          spots: [for (int i = 0; i <= 6; i++) FlSpot(i.toDouble(), dailyGoal)],
          isCurved: false,
          color: Colors.white.withOpacity(0.7),
          barWidth: 2,
          dotData: const FlDotData(show: false),
          dashArray: [5, 5],
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                '',
                const TextStyle(),
                children: [],
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
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt() < days.length ? days[value.toInt()] : '',
        style: style,
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return Text(
      value.toInt() % 250 == 0 ? '${value.toInt()}ml' : '',
      style: style,
      textAlign: TextAlign.left,
    );
  }
}
