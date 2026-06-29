import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(const UserProfileState());

  // In a full implementation, this would connect to a UserRepository to fetch real user data
  void loadProfile() {
    emit(const UserProfileState(
      name: "Abd Elrahman Saeed Ateb Abd Elazim",
      bio: "Dedicated to achieving peak performance through precise nutrition and consistent daily habits.",
      badgesEarned: 15,
      recipesCreated: 47,
      daysTracked: 842,
    ));
  }
}
