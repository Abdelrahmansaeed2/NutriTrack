import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_remote_data_source.dart';

/// Concrete implementation of the [TemplateRepository] contract.
/// Acts as the single source of truth for data, communicating with data sources.
class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource remoteDataSource;

  TemplateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TemplateEntity>> getTemplate(String id) async {
    try {
      // The implementation retrieves the Model from the Data Source.
      final templateModel = await remoteDataSource.fetchTemplate(id);
      
      // Since Model extends Entity, we can return it directly as a success state.
      return Right<Failure, TemplateEntity>(templateModel);
    } catch (e) {
      // Convert exceptions from the Data Source into specific Failures.
      return Left<Failure, TemplateEntity>(ServerFailure(message: 'Failed to fetch template data.'));
    }
  }
}
