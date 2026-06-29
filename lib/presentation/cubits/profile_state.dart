import 'package:equatable/equatable.dart';
import '../../features/auth/models/user_profile_model.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  // Convenience getters
  String get name => profile?.onboarding?.name ?? '';
  String get bio => profile?.onboarding?.bio ?? '';
  String get email => profile?.email ?? '';
  int get targetCalories => profile?.targets?.calories ?? 2000;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
