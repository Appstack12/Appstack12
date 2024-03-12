import 'package:fit_for_life/model/stats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsProvider extends StateNotifier<StatsModel> {
  StatsProvider() : super(StatsModel());

  Future<void> onSaveStats(Map<String, dynamic> data) async {
    final statsData = StatsModel.fromJson(data);
    state = statsData;
  }
}

final statsProvider = StateNotifierProvider<StatsProvider, StatsModel>(
  (ref) => StatsProvider(),
);
