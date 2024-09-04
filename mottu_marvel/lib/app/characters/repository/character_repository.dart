import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'dart:async';

import '../../../core/api/api_routes/api_routes.dart';
import '../../../core/api/failure/failure.dart';
import '../../../core/api/http_service/http_service.dart';
import '../models/character_model.dart';

class CharacterRepository {
  final HttpService _http;

  CharacterRepository({required HttpService http}) : _http = http;

  Future<Either<Failure, List<CharacterModel>>> getCharactersList({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _http.get(
        ApiRoutes.characters,
        queryParameters: {
          'offset': offset.toString(),
          'limit': limit.toString(),
        },
      );
      final data = List<Map<String, dynamic>>.from((response as Map)['data']['results']);
      final characters = data.map((e) => CharacterModel.fromJson(e)).toList();
      return Right(characters);
    } on Exception catch (e, s) {
      return Left(
        Failure(
          message: 'Failed to retrieve character list',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  Future<Either<Failure, CharacterModel>> getCharacterById(int id) async {
    try {
      final response = await _http.get('${ApiRoutes.characters}/$id');
      final data = List<Map<String, dynamic>>.from((response as Map)['data']['results']);
      final characters = data.map((e) => CharacterModel.fromJson(e)).toList();
      return Right(characters.first);
    } on Exception catch (e, s) {
      return Left(
        Failure(
          message: 'Failed to retrieve character',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  Future<Either<Failure, List<CharacterModel>>> filterCharactersByName({required String query}) async {
    try {
      final response = await _http.get(
        ApiRoutes.characters,
        queryParameters: {
          "nameStartsWith": query,
        },
      );

      final data = List<Map<String, dynamic>>.from((response as Map)['data']['results']);
      final characters = data.map((e) => CharacterModel.fromJson(e)).toList();
      return Right(characters);
    } on Exception catch (e, s) {
      return Left(
        Failure(
          message: 'Failed to retrieve characters',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  Future<Either<Failure, List<CharacterModel>>> getRelatedCharacters(
    List<int> comicsId,
    List<int> seriesId,
    List<int> storiesId,
    List<int> eventsId,
  ) async {
    try {
      final response = await _http.get(
        ApiRoutes.characters,
        queryParameters: {
          "comics": comicsId.take(10).join(','),
        },
      );

      final data = List<Map<String, dynamic>>.from((response as Map)['data']['results']);
      final characters = data.map((e) => CharacterModel.fromJson(e)).toList();
      return Right(characters);
    } on Exception catch (e, s) {
      log(e.toString());
      return Left(
        Failure(
          message: 'Failed to retrieve related characters',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }
}
