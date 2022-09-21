import 'package:clean_arch/feature/data/models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();

  Future<void> personsToCache(List<PersonModel> persons);
}
