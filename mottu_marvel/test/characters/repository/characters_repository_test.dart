import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mottu_marvel/app/characters/repository/character_repository.dart';
import 'package:mottu_marvel/core/api/api_routes/api_routes.dart';
import 'package:mottu_marvel/core/api/http_service/http_service.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {
  late CharacterRepository repository;
  late MockHttpService mockHttpService;

  final responseCharacters = {
    'data': {
      'results': [
        {
          'id': 1,
          'name': 'Iron Man',
          'description': '',
          'thumbnail': {'path': 'https://example.com/ironman', 'extension': 'jpg'},
          'comics': {'items': []},
          'series': {'items': []},
          'stories': {'items': []},
          'events': {'items': []},
        },
      ],
    }
  };

  final responseRelatedCharacters = {
    'data': {
      'results': [
        {
          'id': 2,
          'name': 'Spider Man',
          'description': '',
          'thumbnail': {'path': 'https://example.com/spider-man', 'extension': 'jpg'},
          'comics': {'items': []},
          'series': {'items': []},
          'stories': {'items': []},
          'events': {'items': []},
        },
      ],
    }
  };

  setUp(() {
    mockHttpService = MockHttpService();
    repository = CharacterRepository(http: mockHttpService);
  });

  group('CharacterRepository Test', () {
    test('getCharactersList returns a list of characters on success', () async {
      when(
        () => mockHttpService.get(
          ApiRoutes.characters,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => responseCharacters);

      final result = await repository.getCharactersList(offset: 0, limit: 20);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('An error ocurred'),
        (characters) {
          expect(characters.length, 1);
          expect(characters.first.name, 'Iron Man');
        },
      );
    });

    test('getCharactersList returns a Failure on error', () async {
      when(() => mockHttpService.get(ApiRoutes.characters, queryParameters: any(named: 'queryParameters'))).thenThrow(Exception('Failed to fetch data'));

      final result = await repository.getCharactersList(offset: 0, limit: 20);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.message, 'Failed to retrieve character list');
        },
        (_) => fail('An error ocurred'),
      );
    });

    test('getCharacterById returns character on success', () async {
      when(
        () => mockHttpService.get('${ApiRoutes.characters}/1'),
      ).thenAnswer((_) async => responseCharacters);

      final result = await repository.getCharacterById(1);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('An error ocurred'),
        (character) {
          expect(character.name, 'Iron Man');
        },
      );
    });

    test('getCharacterById returns a Failure on error', () async {
      when(() => mockHttpService.get('${ApiRoutes.characters}/1')).thenThrow(Exception('Failed to fetch data'));

      final result = await repository.getCharacterById(1);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.message, 'Failed to retrieve character');
        },
        (_) => fail('An error ocurred'),
      );
    });

    test('filterCharactersByName returns a filtered list of characters on success', () async {
      when(
        () => mockHttpService.get(
          ApiRoutes.characters,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => responseCharacters);

      final result = await repository.filterCharactersByName(query: 'Iron');

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('An error ocurred'),
        (characters) {
          expect(characters.length, 1);
          expect(characters.first.name, 'Iron Man');
        },
      );
    });

    test('filterCharactersByName returns a Failure on error', () async {
      when(() => mockHttpService.get(ApiRoutes.characters, queryParameters: any(named: 'queryParameters'))).thenThrow(Exception('Failed to fetch data'));

      final result = await repository.filterCharactersByName(query: 'Iron');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.message, 'Failed to retrieve characters');
        },
        (_) => fail('An error ocurred'),
      );
    });

    test('getRelatedCharacters returns related characters on success', () async {
      when(
        () => mockHttpService.get(
          ApiRoutes.characters,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => responseRelatedCharacters);

      final result = await repository.getRelatedCharacters([1]);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('An error ocurred'),
        (characters) {
          expect(characters.length, 1);
          expect(characters.first.name, 'Spider Man');
        },
      );
    });

    test('getRelatedCharacters returns a Failure on error', () async {
      when(() => mockHttpService.get(ApiRoutes.characters, queryParameters: any(named: 'queryParameters'))).thenThrow(Exception('Failed to fetch data'));

      final result = await repository.getRelatedCharacters([1]);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.message, 'Failed to retrieve related characters');
        },
        (_) => fail('An error ocurred'),
      );
    });
  });
}
