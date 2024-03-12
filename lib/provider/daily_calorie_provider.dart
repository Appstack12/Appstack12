import 'package:fit_for_life/model/daily_calorie_tracker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyCalorieProvider extends StateNotifier<DailyCalorieTracker> {
  DailyCalorieProvider() : super(DailyCalorieTracker());

  Future<void> onSaveDailyCalorieData(Map<String, dynamic> data) async {
    final dailyCalorieData = DailyCalorieTracker.fromJson(data);

    state = dailyCalorieData;
  }
}

final dailyCalorieProvider =
    StateNotifierProvider<DailyCalorieProvider, DailyCalorieTracker>(
  (ref) => DailyCalorieProvider(),
);
