import 'base_provider.dart';

/// Global App State Provider to manage application-wide session state,
/// theme mode preferences, or global configurations.
class AppStateProvider extends BaseProvider {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// Simulates an initialization check (e.g., verifying cached tokens).
  Future<void> initializeApp() async {
    setLoading(true);
    clearError();
    
    try {
      // Simulate checking local storage or auth tokens
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock result
      _isAuthenticated = false; 
    } catch (e) {
      setError('Failed to initialize app state.');
    } finally {
      setLoading(false);
    }
  }
}
