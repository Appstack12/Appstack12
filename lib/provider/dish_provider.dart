import 'package:fit_for_life/model/dish.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishProvider extends StateNotifier<List<Dish>> {
  DishProvider() : super([]);

  Future<void> onSaveDishes(List data, bool isPagination) async {
    final dishData = DishModel.fromJson(data);
    state = isPagination ? [...state, ...dishData.dishes] : dishData.dishes;
  }
}

final dishProvider = StateNotifierProvider<DishProvider, List<Dish>>(
  (ref) => DishProvider(),
);
