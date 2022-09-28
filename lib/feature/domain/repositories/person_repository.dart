import 'package:dartz/dartz.dart';
import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/feature/domain/entities/person_entity.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);

  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
}
