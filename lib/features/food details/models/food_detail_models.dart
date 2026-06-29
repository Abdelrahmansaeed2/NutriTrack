

class MacroNutrient {
  final String label;
  final double grams;
  final double percentage;

  const MacroNutrient({
    required this.label,
    required this.grams,
    required this.percentage,
  });
}


class MicronutrientTag {
  final String label;
  const MicronutrientTag(this.label);
}


class FoodDetail {
  final String? id;
  final String name;
  final String subtitle;
  final String category;
  final String imageUrl;
  final int totalKcal;
  final int servingGrams;
  final List<MacroNutrient> macros;
  final List<MicronutrientTag> micronutrients;

  const FoodDetail({
    this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.totalKcal,
    required this.servingGrams,
    required this.macros,
    required this.micronutrients,
  });
}