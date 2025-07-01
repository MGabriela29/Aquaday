import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterIntakeEntry {
  final int volumeMl;
  final double goal;
  final DateTime timestamp;

  WaterIntakeEntry({
    required this.volumeMl,
    required this.goal,
    required this.timestamp,
  });
}

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  List<WaterIntakeEntry> waterEntries = [];
  Map<String, double> dailyProgress = {
    'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0,
  };
  Map<String, double> dailyGoals = {
    'Mon': 2000, 'Tue': 2000, 'Wed': 2000, 'Thu': 2000, 'Fri': 2000, 'Sat': 2000, 'Sun': 2000,
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

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));

    Map<String, double> progressMap = {
      'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0,
    };

    Map<String, double> goalMap = {
      'Mon': 2000, 'Tue': 2000, 'Wed': 2000, 'Thu': 2000, 'Fri': 2000, 'Sat': 2000, 'Sun': 2000,
    };

    List<WaterIntakeEntry> entries = [];

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((dateStr, info) {
        final dateParts = dateStr.split('-');
        if (dateParts.length == 3) {
          final date = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );

          double parsedVolume = 0;
          double goal = 2000;

          if (info is Map<dynamic, dynamic>) {
            parsedVolume = (info['intake'] as num?)?.toDouble() ?? 0;
            goal = (info['goal'] as num?)?.toDouble() ?? 2000;
          } else if (info is num) {
            parsedVolume = info.toDouble();
          }

          // Agregamos SIEMPRE la entrada al historial
          entries.add(WaterIntakeEntry(
            volumeMl: parsedVolume.toInt(),
            goal: goal,
            timestamp: date,
          ));

          // Solo si la fecha está dentro de los últimos 7 días, lo agregamos al gráfico
          if (date.isAfter(sevenDaysAgo.subtract(const Duration(days: 1))) &&
              date.isBefore(now.add(const Duration(days: 1)))) {
            final weekday = _getWeekdayLabel(date.weekday);

            progressMap[weekday] = (progressMap[weekday] ?? 0) + parsedVolume;
            goalMap[weekday] = goal;
          }
        }
      });
    }
    
    
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {
      waterEntries = entries;
      dailyProgress = progressMap;
      dailyGoals = goalMap;
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
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 30, bottom: 2),
                  child: LineChart(mainData()),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                  '${entry.volumeMl} ml / ${entry.goal.toInt()} ml',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_formatDate(entry.timestamp)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
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

  // Ya no necesitas _formatTime porque no se muestra

  LineChartData mainData() {
    final List<String> weekOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    double maxYValue = 0;

    for (int i = 0; i < weekOrder.length; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final dateKey = '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final value = dailyProgress[weekOrder[i]] ?? 0;
      final goal = waterEntries.firstWhere(
        (e) => e.timestamp.toIso8601String().substring(0, 10) == dateKey,
        orElse: () => WaterIntakeEntry(volumeMl: 0, goal: 2000, timestamp: date),
      ).goal;

      maxYValue = [maxYValue, value, goal].reduce((a, b) => a > b ? a : b);
    }

    maxYValue *= 1.1;

    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 250, verticalInterval: 1),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: getBottomTitles),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, interval: 250, getTitlesWidget: getLeftTitles, reservedSize: 52),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.white, width: 0.5),
          bottom: BorderSide(color: Colors.white, width: 0.5),
          right: BorderSide(color: Colors.white, width: 0.5),
        ),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: maxYValue,
      lineBarsData: [
        LineChartBarData(
          spots: weekOrder.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final value = dailyProgress[day] ?? 0;
            return FlSpot(index.toDouble(), value);
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade500]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 3, strokeColor: Colors.blue.shade700);
          }),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.blue.shade200.withOpacity(0.3), Colors.blue.shade500.withOpacity(0.3)],
            ),
          ),
        ),
        LineChartBarData(
          spots: List.generate(7, (i) {
            final day = weekOrder[i];
            final goal = dailyGoals[day] ?? 2000;
            return FlSpot(i.toDouble(), goal);
          }),
          isCurved: false,
          color: Colors.white.withOpacity(0.7),
          barWidth: 2,
          dotData: const FlDotData(show: false),
          dashArray: [5, 5],
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 12,
          tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          tooltipMargin: 12,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((barSpot) {
              final x = barSpot.x.toInt();
              final day = (x >= 0 && x < weekOrder.length) ? weekOrder[x] : 'Day';
              final y = barSpot.y;
              final goal = dailyGoals[day] ?? 2000;
              final met = y >= goal;

              final isGoalLine = barSpot.barIndex == 1;
              if (isGoalLine) return null;

              return LineTooltipItem(
                '$day\n',
                const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Daily Goal: ${goal.toInt()} ml \n',
                    style: TextStyle(
                      color: met ? const Color.fromARGB(255, 105, 233, 240) : Colors.lightBlue.shade50,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: 'Progress: ${y.toInt()} ml',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
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
