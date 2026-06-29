import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_track/core/networking/api_service.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);


  Future<UserModel> loginWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _fetchProfile(credential.user);
  }

  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _fetchProfile(credential.user);
  }

  Future<UserModel> _fetchProfile(User? user) async {
    if (user == null) throw Exception('Firebase authentication failed');

    String? token = await user.getIdToken();

    if (token == null) throw Exception('Failed to obtain authentication token');
    _apiClient.token = token;
    final response = await _apiClient.get('/api/users/profile');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized backend request');
    } else {
      // Profile may not exist yet for new users — return a minimal model
      return UserModel(uid: user.uid, email: user.email ?? '', name: '');
    }
  }
}
