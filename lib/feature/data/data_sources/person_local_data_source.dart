import 'dart:convert';

import 'package:clean_arch/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_arch/feature/data/models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();

  Future<void> personsToCache(List<PersonModel> persons);
}

const cachedPersonsList = 'CACHED_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() async {
    final jsonPersonsList = sharedPreferences.getStringList(cachedPersonsList);
    if (jsonPersonsList != null) {
      return Future.value(jsonPersonsList
          .map((person) => PersonModel.fromJson(json.decode(person)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) async {
    final List<String> jsonPersonsList =
        persons.map((person) => json.encode(person.toJson())).toList();
    sharedPreferences.setStringList(cachedPersonsList, jsonPersonsList);
    Future.value(jsonPersonsList);
  }
}
