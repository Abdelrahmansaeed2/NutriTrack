import 'package:equatable/equatable.dart';

class UserProfileState extends Equatable {
  final String name;
  final String bio;
  final String avatarUrl;
  final int badgesEarned;
  final int recipesCreated;
  final int daysTracked;

  const UserProfileState({
    this.name = "Abd Elrahman Saeed Ateb Abd Elazim",
    this.bio = "Dedicated to achieving peak performance through precise nutrition and consistent daily habits.",
    this.avatarUrl = "",
    this.badgesEarned = 15,
    this.recipesCreated = 47,
    this.daysTracked = 842,
  });

  UserProfileState copyWith({
    String? name,
    String? bio,
    String? avatarUrl,
    int? badgesEarned,
    int? recipesCreated,
    int? daysTracked,
  }) {
    return UserProfileState(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      recipesCreated: recipesCreated ?? this.recipesCreated,
      daysTracked: daysTracked ?? this.daysTracked,
    );
  }

  @override
  List<Object?> get props => [name, bio, avatarUrl, badgesEarned, recipesCreated, daysTracked];
}
