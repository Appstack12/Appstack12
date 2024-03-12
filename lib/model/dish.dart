class DishModel {
  DishModel({
    required this.dishes,
  });

  factory DishModel.fromJson(List data) {
    final List<Dish> dishes = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        dishes.add(Dish.fromJson(data[i]));
      }
    }

    return DishModel(dishes: dishes);
  }

  final List<Dish> dishes;
}

class Dish {
  Dish({
    required this.dishId,
    required this.dishName,
    required this.quantity_type,
    required this.ingredients,
    required this.calories,
    required this.grams,
    required this.quantity,
  });

  factory Dish.fromJson(Map<String, dynamic> data) {
    return Dish(
      dishId: data['id'] ?? '',
      dishName: data['food'] ?? '',
      ingredients: data['ingredients'] ?? '',
      calories: double.parse((data["cals"] ?? 0)?.toStringAsFixed(2)),
      grams:data["quantity_weight"] ?? '',
      quantity_type: data["quantity_type"]?? '',
      quantity: data["quantity"]?? '',

    );
  }

  final int dishId;
  final String dishName;
  final String ingredients;
  final String quantity_type;
  final String quantity;
  final double calories;
  final String grams;
}
