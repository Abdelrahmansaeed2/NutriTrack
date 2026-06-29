import 'package:flutter/material.dart';
import 'package:nutri_track/features/auth/login/data/models/user_model.dart';
import 'package:nutri_track/features/auth/login/data/repo/auth_repo.dart';


class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;

  bool _isConfirmPasswordHidden = true;
  bool get isConfirmPasswordHidden => _isConfirmPasswordHidden;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUser;

  RegisterViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;
  UserModel? get currentUser => _currentUser;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser =
          await _authRepository.registerWithEmailAndPassword(email, password);
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
