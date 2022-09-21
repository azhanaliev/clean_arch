import 'dart:convert';

import 'package:clean_arch/core/error/exception.dart';
import 'package:clean_arch/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPersons(int page);

  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;

  PersonRemoteDataSourceImpl(this.client);

  @override
  Future<List<PersonModel>> getAllPersons(int page) async => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?page=$page');

  @override
  Future<List<PersonModel>> searchPerson(String query) async =>
      _getPersonFromUrl(
          'https://rickandmortyapi.com/api/character/?name=$query');

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
