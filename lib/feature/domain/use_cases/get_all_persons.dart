import 'package:clean_arch/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/feature/domain/entities/person_entity.dart';
import 'package:clean_arch/feature/domain/repositories/person_repository.dart';
import 'package:equatable/equatable.dart';

class GetAllPersons extends UseCase<List<PersonEntity>, PagePersonParams> {
  final PersonRepository personRepository;

  GetAllPersons(this.personRepository);

  @override
  Future<Either<Failure, List<PersonEntity>>> call(PagePersonParams params) async =>
      await personRepository.getAllPersons(params.page);
}

class PagePersonParams extends Equatable {
  final int page;

  const PagePersonParams({required this.page});

  @override
  List<Object> get props => [page];
}
