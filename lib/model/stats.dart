import 'package:fit_for_life/model/calorigram.dart';
import 'package:fit_for_life/model/dish_detail.dart';
import 'package:fit_for_life/strings/index.dart';

class StatsModel {
  StatsModel({
    this.eatenCalories,
    this.remainingCalories,
    this.nutritionValues = const [],
    this.eatenCaloriesBreakdown,
  });

  factory StatsModel.fromJson(Map<String, dynamic> data) {
    return StatsModel(
      eatenCalories: data['eaten_calories'] ?? 0,
      remainingCalories: data['remaining_calories'] ?? 0,
      nutritionValues:
          NutritionModel.fromJson(data['nutrition_value']).nutritionValues,
      eatenCaloriesBreakdown: [
        Calorigram(
            label: Strings.breakfast,
            calorie: data['eaten_calories_breakdown']['breakfast']),
        Calorigram(
            label: Strings.lunch,
            calorie: data['eaten_calories_breakdown']['lunch']),
        Calorigram(
            label: Strings.snacks,
            calorie: data['eaten_calories_breakdown']['evening_snacks']),
        Calorigram(
            label: Strings.dinner,
            calorie: data['eaten_calories_breakdown']['dinner']),
        Calorigram(
            label: "Other",
            calorie: data['eaten_calories_breakdown']['other']),
      ],
    );
  }

  final dynamic eatenCalories;
  final dynamic remainingCalories;
  final List<NutritionValues> nutritionValues;
  final List<Calorigram>? eatenCaloriesBreakdown;
}
