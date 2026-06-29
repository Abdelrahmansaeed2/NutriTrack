import '../../../core/network/api_client.dart';
import '../models/analytics_model.dart';

class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance {
    _instance ??= AnalyticsService._();
    return _instance!;
  }
  AnalyticsService._();

  /// GET /api/analytics/dashboard
  Future<AnalyticsDashboard> getDashboardStats() async {
    final response = await ApiClient.instance.get('/api/analytics/dashboard');
    return AnalyticsDashboard.fromJson(response.data as Map<String, dynamic>);
  }

  /// GET /api/analytics/export
  Future<Map<String, dynamic>> exportData() async {
    final response = await ApiClient.instance.get('/api/analytics/export');
    return response.data as Map<String, dynamic>;
  }
}
