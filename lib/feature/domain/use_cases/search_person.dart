import 'package:clean_arch/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/feature/domain/entities/person_entity.dart';
import 'package:clean_arch/feature/domain/repositories/person_repository.dart';
import 'package:equatable/equatable.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson(this.personRepository);

  @override
  Future<Either<Failure, List<PersonEntity>>> call(
          SearchPersonParams params) async =>
      await personRepository.searchPerson(params.query);
}

class SearchPersonParams extends Equatable {
  final String query;

  const SearchPersonParams({required this.query});

  @override
  List<Object> get props => [query];
}