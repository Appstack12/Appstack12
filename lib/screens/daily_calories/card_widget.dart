import 'package:fit_for_life/model/dish.dart';
import 'package:fit_for_life/model/meal.dart';
import 'package:fit_for_life/widgets/meal_card.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.calorieData,
    
    this.onRemoveDish,
    required this.selectedDate,
  });

  final List<Dish> calorieData;
  final void Function(Meal meal)? onRemoveDish;
  final int selectedDate;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return MealCard(
      data: widget.calorieData
          .map(
            (e) => Meal(
              calorie: e.calories.toString(),
              dishName: e.dishName,
              quantity_type: e.quantity_type,
              quantity: e.quantity,
              // ingredients: e.ingredients,
              grams: e.grams,
              id: e.dishId,
              icon: widget.selectedDate == 6 ? Icons.close : null,
            ),
          )
          .toList(),
      padding: 16,
      onClickIcon: widget.selectedDate == 6
          ? (widget.onRemoveDish ?? (Meal meal) {})
          : (Meal meal) {},
    );
  }
}
