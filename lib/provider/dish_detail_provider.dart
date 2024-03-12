import 'package:fit_for_life/model/dish_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishDetailProvider extends StateNotifier<DishDetail> {
  DishDetailProvider() : super(DishDetail());

  Future<void> onSaveDishDetail(Map<String, dynamic> data) async {
    final dishData = DishDetail.fromJson(data);
    state = dishData;
  }
}

final dishDetailProvider =
    StateNotifierProvider<DishDetailProvider, DishDetail>(
  (ref) => DishDetailProvider(),
);
