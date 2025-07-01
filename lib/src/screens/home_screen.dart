import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int dailyGoal = 2000;
  int currentIntake = 0;
  List<int> waterAmounts = [];
  int selectedAmount = 0;

  late TextEditingController dailyGoalController;

  @override
  void initState() {
    super.initState();
    dailyGoalController = TextEditingController(text: dailyGoal.toString());
    syncUserWithRealtimeDB();
    fetchWaterData();
    generateWaterAmounts();
  }

  @override
  void dispose() {
    dailyGoalController.dispose();
    super.dispose();
  }

    void generateWaterAmounts() {
    setState(() {
      waterAmounts = [
        (dailyGoal * 0.1).round(),
        (dailyGoal * 0.2).round(),
        (dailyGoal * 0.25).round(),
        (dailyGoal * 0.5).round(),
      ];
      selectedAmount = waterAmounts.first;
    });
  }

  Future<void> syncUserWithRealtimeDB() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final userRef = FirebaseDatabase.instance.ref('users/$uid');
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      await userRef.set({
        'dailyGoal': dailyGoal,
        'currentIntake': 0,
      });
    }
  }

Future<void> fetchWaterData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final uid = user.uid;
  final userRef = FirebaseDatabase.instance.ref('users/$uid');

  userRef.onValue.listen((event) async {
    final data = event.snapshot.value as Map?;
    if (data != null) {
      final lastUpdatedString = data['lastUpdated'] ?? '';
      final currentDate = DateTime.now();
      final lastUpdatedDate = DateTime.tryParse(lastUpdatedString) ?? currentDate;

      final isNewDay = currentDate.day != lastUpdatedDate.day ||
          currentDate.month != lastUpdatedDate.month ||
          currentDate.year != lastUpdatedDate.year;

      if (isNewDay) {
        // Reinicia el contador si es un nuevo día
        await userRef.update({
          'currentIntake': 0,
          'dailyGoal': 2000,
          'lastUpdated': currentDate.toIso8601String(),
        });

        setState(() {
          currentIntake = 0;
          // dailyGoal = data['dailyGoal'] ?? 2000;
          dailyGoal = 2000;
          dailyGoalController.text = dailyGoal.toString();
        });
      } else {
        // Día actual, solo sincroniza valores
        setState(() {
          dailyGoal = data['dailyGoal'] ?? 2000;
          currentIntake = data['currentIntake'] ?? 0;
          dailyGoalController.text = dailyGoal.toString();
          generateWaterAmounts();
        });
      }
    }
  });
}


  void addWater(int amount) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final uid = user.uid;
  final userRef = FirebaseDatabase.instance.ref('users/$uid');

  final newTotal = currentIntake + amount;

    final dateKey = DateTime.now().toIso8601String().substring(0, 10);

  await userRef.update({
    'currentIntake': newTotal,
    'lastUpdated': DateTime.now().toIso8601String(),
      // 'historial/${DateTime.now().toIso8601String().substring(0, 10)}': newTotal,
      'dailyGoal': dailyGoal,
  });

  final historialRef = FirebaseDatabase.instance.ref('users/$uid/historial/$dateKey');
  await historialRef.set({
    'intake': newTotal,
    'goal': dailyGoal,
  });

  setState(() {
    currentIntake = newTotal;
  });

  if (newTotal == dailyGoal) {
    // SnackBar discreto si alcanza justo la meta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Congratulations! You have reached your daily goal!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(255, 18, 0, 108),
        duration: Duration(seconds: 3),
      ),
    );
  } else if (newTotal > dailyGoal) {
    // Alerta si la supera
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("¡Goal Surpassed!"),
          content: Text("You have surpassed your daily goal of $dailyGoal ml."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    });
  }
}


  Future <void> updateDailyGoal(int newGoal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final userRef = FirebaseDatabase.instance.ref('users/$uid');

    await userRef.update({
      'dailyGoal': newGoal,
    });

      // así el historial tendrá siempre la meta correcta.
  final dateKey = DateTime.now().toIso8601String().substring(0, 10);
  final historialRef = FirebaseDatabase.instance.ref('users/$uid/historial/$dateKey');
  final snapshot = await historialRef.get();

  int intake = 0;
  if (snapshot.exists) {
    final data = snapshot.value as Map;
    intake = (data['intake'] as num?)?.toInt() ?? 0;
  }

  await historialRef.set({
    'intake': intake,
    'goal': newGoal,
  });

    setState(() {
      dailyGoal = newGoal;
    });

    generateWaterAmounts();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentIntake / dailyGoal).clamp(0.0, 1.0);

    void onItemTapped(int index) {
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacementNamed(context, AppRoutes.alarmsRoute);
          break;
        case 2:
          Navigator.pushReplacementNamed(context, AppRoutes.historialRoute);
          break;
        case 3:
          Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
          break;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 70, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your daily goal is',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Color(0xFF04246C),
              ),
            ),
            const SizedBox(height: 15),

            // Input con icono y palomita para guardar meta diaria
             Padding(
              padding: const EdgeInsets.fromLTRB(75, 0, 80, 0),
            child: Row( 

              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                  child: TextField(
                    controller: dailyGoalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Daily goal (ml)',
                        hintText: 'Enter your daily goal',
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF04246C),
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.water_drop, color: Color(0xFF04246C)),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(19),
                          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        isDense: true,
                     ),
                    onSubmitted: (_) {
                      final newGoal = int.tryParse(dailyGoalController.text);
                      if (newGoal != null && newGoal > 0 && newGoal <= 3000) {
                        updateDailyGoal(newGoal);
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Goal updated successfully'),
                            backgroundColor: Color.fromARGB(255, 18, 0, 108),
                          ),
                        );
                      } else {
                        dailyGoalController.text = dailyGoal.toString();
                        String errorMsg = (newGoal != null && newGoal > 3000)
                            ? 'The maximum daily goal is 3000 ml.'
                            : 'Please enter a valid number';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMsg),
                            backgroundColor: const Color.fromARGB(255, 201, 14, 14),
                          ),
                        );
                      }
                    },
                  ),
                ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Color(0xFF04246C)),
                  tooltip: 'Save Daily Goal',
                onPressed: () {
                  final newGoal = int.tryParse(dailyGoalController.text);
                  if (newGoal != null && newGoal > 0 && newGoal <= 3000) {
                    updateDailyGoal(newGoal);
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Goal updated successfully'),
                        backgroundColor: Color.fromARGB(255, 18, 0, 108),
                      ),
                    );
                  } else {
                    dailyGoalController.text = dailyGoal.toString();
                    String errorMsg = (newGoal != null && newGoal > 3000)
                        ? 'The maximum daily goal is 3000 ml.'
                        : 'Please enter a valid number';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMsg),
                        backgroundColor: const Color.fromARGB(255, 201, 14, 14),
                      ),
                    );
                  }
                }
                ),
              ],
            ),
            ),

            const SizedBox(height: 40),

            CircularPercentIndicator(
              radius: 130.0,
              lineWidth: 25.0,
              percent: progress,
              center: Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.blue.shade600,
              backgroundColor: Colors.blue.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),

            const SizedBox(height: 60),
            const Text(
              'Select the amount of water you want to drink',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),

            // Lista horizontal de cantidades de agua
            const SizedBox(height: 40),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: waterAmounts.length,
                itemBuilder: (context, index) {
                  final amount = waterAmounts[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmount = amount;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedAmount == amount ? const Color.fromARGB(255, 187, 237, 251) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue.shade300,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 35, 85).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_drink,
                            size: 50,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            '$amount ml',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                addWater(selectedAmount);
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: const Text(
                'Drink',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 0,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
