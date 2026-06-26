import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/template_entity.dart';

/// Abstract contract defining the interactions required by the Domain Layer.
/// The data layer must implement this interface.
abstract class TemplateRepository {
  /// Retrieves a TemplateEntity by its ID.
  /// Returns [Left(Failure)] if an error occurs, or [Right(TemplateEntity)] upon success.
  Future<Either<Failure, TemplateEntity>> getTemplate(String id);
}
