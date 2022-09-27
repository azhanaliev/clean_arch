import 'package:clean_arch/core/error/exception.dart';
import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/core/platform/network_info.dart';
import 'package:clean_arch/feature/data/data_sources/person_local_data_source.dart';
import 'package:clean_arch/feature/data/data_sources/person_remote_data_source.dart';
import 'package:clean_arch/feature/data/models/person_model.dart';
import 'package:clean_arch/feature/domain/entities/person_entity.dart';
import 'package:clean_arch/feature/domain/repositories/person_repository.dart';
import 'package:dartz/dartz.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSourceImpl personRemoteDataSourceImpl;
  final PersonLocalDataSourceImpl personLocalDataSourceImpl;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl(
    this.personRemoteDataSourceImpl,
    this.personLocalDataSourceImpl,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async =>
      _getPersons(() => personRemoteDataSourceImpl.getAllPersons(page));

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(
          String query) async =>
      _getPersons(() => personRemoteDataSourceImpl.searchPerson(query));

  _getPersons(Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePersons = await getPersons();
        personLocalDataSourceImpl.personsToCache(remotePersons);
        return Right(remotePersons);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPersons =
            await personLocalDataSourceImpl.getLastPersonsFromCache();
        return Right(localPersons);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
