import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/template_model.dart';

class TemplateService {
  Future<Either<Failure, TemplateModel>> fetchTemplate(String id) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate fetching data
      final templateModel = TemplateModel(id: id, name: 'Mock Data Name');
      return Right(templateModel);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch template data.'));
    }
  }
}
