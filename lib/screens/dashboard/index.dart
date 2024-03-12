import 'package:fit_for_life/screens/daily_calories/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  void _onNavigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const DailyCaloriesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Dashboard'),
              ElevatedButton(
                onPressed: _onNavigate,
                child: const Text('Calorie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
