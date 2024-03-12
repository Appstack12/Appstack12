import 'package:fit_for_life/model/add_new_recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRecipeProvider extends StateNotifier<List<IngredientsList>> {
  AddNewRecipeProvider() : super([]);

  Future<void> onSaveIngredients(List<dynamic> data) async {
    final ingredientsList = IngredientsListModel.fromJson(data);

    state = ingredientsList.ingredientsList;
  }
}

final addNewRecipeProvider =
    StateNotifierProvider<AddNewRecipeProvider, List<IngredientsList>>(
  (ref) => AddNewRecipeProvider(),
);
