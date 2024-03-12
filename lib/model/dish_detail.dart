class DishDetail {
  DishDetail({
    this.dishName = '',
    this.calories = 0,
    this.nutritionValues = const [],
    this.recipeValues = const [],
  });

  factory DishDetail.fromJson(Map<String, dynamic> data) {
    return DishDetail(
      dishName: data['dish_name'] ?? '',
      calories: data['calories'] ?? 0,
      nutritionValues:
          NutritionModel.fromJson(data['nutrition_value']).nutritionValues,
      recipeValues: data['recipes'],
    );
  }

  final String? dishName;
  final double? calories;
  final List<NutritionValues>? nutritionValues;
  final List<dynamic>? recipeValues;
}

class NutritionModel {
  NutritionModel({
    required this.nutritionValues,
  });

  factory NutritionModel.fromJson(List data) {
    final List<NutritionValues> nutritionValues = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        nutritionValues.add(NutritionValues.fromJson(data[i]));
      }
    }

    return NutritionModel(nutritionValues: nutritionValues);
  }

  final List<NutritionValues> nutritionValues;
}

class NutritionValues {
  NutritionValues({
    required this.name,
    required this.quantity,
    required this.percentage,
    required this.colour,
    required this.unit,
  });

  factory NutritionValues.fromJson(Map<String, dynamic> data) {
    return NutritionValues(
      name: data['label'] ?? '',
      quantity: data['value'] ?? 0,
      percentage: data['percentage'] ?? 0,
      colour: data["color_code"] ?? '#29B6C7',
      unit: data["unit"] ?? '',
    );
  }

  final String name;
  final dynamic quantity;
  final dynamic percentage;
  final String colour;
  final String unit;
}
