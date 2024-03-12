class Ingredient {
  Ingredient({
    required this.ingredientName,
    required this.quantity,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["dishes"] = id;
    data["quantity"] = quantity;
    return data;
  }

  final String ingredientName;
  final double quantity;
  final int id;
}

class IngredientsListModel {
  IngredientsListModel({
    required this.ingredientsList,
  });

  factory IngredientsListModel.fromJson(List data) {
    final List<IngredientsList> ingredientsList = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        ingredientsList.add(IngredientsList.fromJson(data[i]));
      }
    }

    return IngredientsListModel(ingredientsList: ingredientsList);
  }

  final List<IngredientsList> ingredientsList;
}

class IngredientsList {
  IngredientsList({
    required this.ingredientName,
    required this.id,
  });

  factory IngredientsList.fromJson(Map<String, dynamic> data) {
    return IngredientsList(
      ingredientName: data['name'] ?? '',
      id: data['id'] ?? 0,
    );
  }

  final String ingredientName;
  final int id;
}
