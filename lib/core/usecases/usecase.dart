import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Generic base class for all UseCases.
/// Enforces the signature `Future<Either<Failure, T>> call(Params params)`.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// A wrapper class when a UseCase requires no parameters.
class NoParams {
  const NoParams();
}
