import '../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

class UserService {
  static UserService? _instance;
  static UserService get instance {
    _instance ??= UserService._();
    return _instance!;
  }
  UserService._();

  /// GET /api/users/profile
  Future<UserProfile> getProfile() async {
    final response = await ApiClient.instance.get('/api/users/profile');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/users/onboard
  Future<UserProfile> onboardUser(Map<String, dynamic> data) async {
    final response = await ApiClient.instance.post('/api/users/onboard', data: data);
    final body = response.data as Map<String, dynamic>;
    return UserProfile.fromJson(body['profile'] as Map<String, dynamic>);
  }

  /// PUT /api/users/profile
  Future<UserProfile> updateProfile(Map<String, dynamic> data) async {
    final response = await ApiClient.instance.put('/api/users/profile', data: data);
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /api/users/recalculate-targets
  Future<Map<String, dynamic>> recalculateTargets(double weightKg) async {
    final response = await ApiClient.instance.post(
      '/api/users/recalculate-targets',
      data: {'weightKg': weightKg},
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /api/users/sync-health
  Future<void> syncHealth() async {
    await ApiClient.instance.post('/api/users/sync-health');
  }

  /// POST /api/users/support
  Future<void> submitSupport(String message) async {
    await ApiClient.instance.post('/api/users/support', data: {'message': message});
  }
}
