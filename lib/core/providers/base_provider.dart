import 'package:flutter/foundation.dart';

/// Abstract BaseProvider to be extended by all Feature Providers.
/// Encapsulates common state variables and UI control flows.
abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  /// Indicates if the provider is currently processing an async operation.
  bool get isLoading => _isLoading;

  /// Contains the latest error message, or null if no error occurred.
  String? get errorMessage => _errorMessage;

  /// Utility method to safely toggle loading state.
  void setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// Utility method to safely set an error message.
  void setError(String message) {
    _errorMessage = message;
    _isLoading = false; // Usually, setting an error implies loading is done
    notifyListeners();
  }

  /// Utility method to clear the current error message.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
