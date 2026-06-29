import 'package:equatable/equatable.dart';

abstract class FoodDetailState extends Equatable {
  const FoodDetailState();

  @override
  List<Object?> get props => [];
}

class FoodDetailInitial extends FoodDetailState {}

class FoodDetailSubmitting extends FoodDetailState {}

class FoodDetailSuccess extends FoodDetailState {
  final String message;

  const FoodDetailSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FoodDetailError extends FoodDetailState {
  final String message;

  const FoodDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
