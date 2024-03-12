import 'package:flutter/material.dart';

class Meal {
  final String dishName;
  // final String ingredients;
  final String calorie;
  final String grams;
  final String quantity_type;
  final String quantity;
  final int id;
  final IconData? icon;
  int counter;

  Meal({
    required this.dishName,
    // required this.ingredients,
    required this.calorie,
    required this.grams,
    required this.quantity_type,
    required this.quantity,
    required this.id,
    this.icon,
     
    
  }): counter = int.tryParse(quantity) ?? 0;
   


}
