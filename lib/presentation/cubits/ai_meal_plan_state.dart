import 'package:equatable/equatable.dart';

enum AIMealPlanStatus { initial, loading, generated, error }

class AIMealPlanState extends Equatable {
  final AIMealPlanStatus status;
  final bool isVegetarian;
  final bool isKeto;
  final bool isHalal;
  final String allergiesText;
  final int dailyMeals;
  final String? generatedPlanId;
  final String? errorMessage;

  const AIMealPlanState({
    this.status = AIMealPlanStatus.initial,
    this.isVegetarian = false,
    this.isKeto = false,
    this.isHalal = false,
    this.allergiesText = '',
    this.dailyMeals = 3,
    this.generatedPlanId,
    this.errorMessage,
  });

  bool get isLoading => status == AIMealPlanStatus.loading;

  AIMealPlanState copyWith({
    AIMealPlanStatus? status,
    bool? isVegetarian,
    bool? isKeto,
    bool? isHalal,
    String? allergiesText,
    int? dailyMeals,
    String? generatedPlanId,
    String? errorMessage,
  }) {
    return AIMealPlanState(
      status: status ?? this.status,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isKeto: isKeto ?? this.isKeto,
      isHalal: isHalal ?? this.isHalal,
      allergiesText: allergiesText ?? this.allergiesText,
      dailyMeals: dailyMeals ?? this.dailyMeals,
      generatedPlanId: generatedPlanId ?? this.generatedPlanId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isVegetarian,
        isKeto,
        isHalal,
        allergiesText,
        dailyMeals,
        generatedPlanId,
        errorMessage,
      ];
}
