
import 'package:flutter/material.dart';


class RecipeIngredient {
  final String name;
  final String quantity;
  final int kcal;

  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.kcal,
  });

  RecipeIngredient copyWith({String? name, String? quantity, int? kcal}) {
    return RecipeIngredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      kcal: kcal ?? this.kcal,
    );
  }
}


class RecipeMacros {
  final double protein;
  final double carbs;
  final double fat;
  final int totalKcal;

  const RecipeMacros({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.totalKcal,
  });

  
  factory RecipeMacros.fromIngredients(List<RecipeIngredient> ingredients) {
    final totalKcal = ingredients.fold(0, (sum, i) => sum + i.kcal);
    
    return RecipeMacros(
      protein: totalKcal * 0.116, 
      carbs:   totalKcal * 0.096, 
      fat:     totalKcal * 0.020, 
      totalKcal: totalKcal,
    );
  }
}


class MacroRingData {
  final String label;
  final double grams;
  final Color ringColor;
  final Color bgColor;
  final double progress; 

  const MacroRingData({
    required this.label,
    required this.grams,
    required this.ringColor,
    required this.bgColor,
    required this.progress,
  });
}