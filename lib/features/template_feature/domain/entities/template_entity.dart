/// Base Entity representing pure business rules and data.
/// This layer has absolutely no dependencies on Flutter, JSON, or external libraries.
class TemplateEntity {
  final String id;
  final String name;

  const TemplateEntity({
    required this.id,
    required this.name,
  });
}
