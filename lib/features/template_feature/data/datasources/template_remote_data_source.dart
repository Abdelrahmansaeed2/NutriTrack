import '../models/template_model.dart';

/// Abstract contract for remote data interactions.
abstract class TemplateRemoteDataSource {
  /// Fetches template data from an external API or database.
  /// Throws a custom Exception on failure.
  Future<TemplateModel> fetchTemplate(String id);
}

/// Mock Implementation of the Remote Data Source.
class MockTemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  @override
  Future<TemplateModel> fetchTemplate(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate fetching data
    return TemplateModel(id: id, name: 'Mock Data Name');
  }
}
