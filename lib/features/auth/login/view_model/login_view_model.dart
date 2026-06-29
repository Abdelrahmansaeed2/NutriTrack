import 'package:flutter/material.dart';
import 'package:nutri_track/features/auth/login/data/repo/auth_repo.dart';

import '../data/models/user_model.dart';


class LoginViewModel extends ChangeNotifier {

  LoginViewModel(this._authRepository);
  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}