import '../../domain/entities/template_entity.dart';

/// Data Model extending the pure Entity.
/// This handles data transformation (e.g., JSON serialization).
class TemplateModel extends TemplateEntity {
  const TemplateModel({
    required super.id,
    required super.name,
  });

  /// Factory constructor to map JSON to the Model.
  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  /// Method to map the Model back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
