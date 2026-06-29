import 'package:equatable/equatable.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeSuccess extends RecipeState {}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}
