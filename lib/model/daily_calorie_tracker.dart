import 'package:fit_for_life/model/dish.dart';
import 'package:fit_for_life/model/progress_data.dart';
import 'package:fit_for_life/strings/index.dart';

class DailyCalorieTracker {
  final dynamic caloriesUsed;
  final dynamic totalCalories;
  final List<ProgressData>? calorieBreakdown;
  final List<Dish>? breakfast;
  final List<Dish>? lunch;
  final List<Dish>? eveningSnacks;
  final List<Dish>? dinner;
  final List<Dish>? other;
  final List<dynamic>? dishIds;

  factory DailyCalorieTracker.fromJson(Map<String, dynamic> data) {
    return DailyCalorieTracker(
      caloriesUsed: data['calories_used'] ?? 0,
      totalCalories: data['total_calory'] ?? 0,
      calorieBreakdown: [
        ProgressData(
          label: Strings.carbs,
          progress: data['calorie_breakdown']['carbs']['percentage'] ?? 0,
          color: data['calorie_breakdown']['carbs']['color'] ?? '#2CA3FA',
          value: data['calorie_breakdown']['carbs']['value'] ?? 0,
        ),
        ProgressData(
          label: Strings.proteins,
          progress: data['calorie_breakdown']['proteins']['percentage'] ?? 0,
          color: data['calorie_breakdown']['proteins']['color'] ?? '#FF7326',
          value: data['calorie_breakdown']['proteins']['value'] ?? 0,
        ),
        ProgressData(
          label: Strings.fats,
          progress: data['calorie_breakdown']['fats']['percentage'] ?? 0,
          color: data['calorie_breakdown']['fats']['color'] ?? '#81BE00',
          value: data['calorie_breakdown']['fats']['value'] ?? 0,
        ),
        ProgressData(
          label: Strings.gl,
          progress: data['calorie_breakdown']['gl']['percentage'] ?? 0,
          color: data['calorie_breakdown']['gl']['color'] ?? '#81BE00',
          value: data['calorie_breakdown']['gl']['value'] ?? 0,
        )
      ],
      breakfast: DishModel.fromJson(data['breakfast'] ?? []).dishes,
      lunch: DishModel.fromJson(data['lunch'] ?? []).dishes,
      eveningSnacks: DishModel.fromJson(data['evening_snacks'] ?? []).dishes,
      dinner: DishModel.fromJson(data['dinner'] ?? []).dishes,
      other: DishModel.fromJson(data['other'] ?? []).dishes,
      dishIds: data['added_dish'],
    );
  }

  DailyCalorieTracker({
    this.caloriesUsed,
    this.totalCalories,
    this.calorieBreakdown,
    this.breakfast,
    this.lunch,
    this.eveningSnacks,
    this.dinner,
    this.other,
    this.dishIds,
  });
}

class DishModel {
  DishModel({
    required this.dishes,
  });

  factory DishModel.fromJson(List data) {
    final List<Dish> nutritionValues = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        nutritionValues.add(Dish.fromJson(data[i]));
      }
    }

    return DishModel(dishes: nutritionValues);
  }

  final List<Dish> dishes;
}
