import 'package:dartz/dartz.dart';
import 'dart:async';

import '../../../core/api/api_routes/api_routes.dart';
import '../../../core/api/failure/failure.dart';
import '../../../core/api/http_service/http_service.dart';
import '../models/character_model.dart';

class CharacterRepository {
  final HttpService _http;

  CharacterRepository({required HttpService http}) : _http = http;

  Future<Either<Failure, List<CharacterModel>>> getCharactersList() async {
    try {
      final response = await _http.get(ApiRoutes.characters);
      final data = List<Map<String, dynamic>>.from((response as Map)['data']['results']);
      final characters = data.map((e) => CharacterModel.fromJson(e)).toList();
      return Right(characters);
    } on Exception catch (e, s) {
      return Left(Failure(
        message: 'Failed to retrieve character list',
        exception: e,
        stackTrace: s,
      ));
    }
  }
}
