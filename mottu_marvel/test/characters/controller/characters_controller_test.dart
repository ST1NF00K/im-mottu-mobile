import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mottu_marvel/app/characters/cache/caracters_cache.dart';
import 'package:mottu_marvel/app/characters/controller/characters_controller.dart';
import 'package:mottu_marvel/app/characters/models/character_model.dart';
import 'package:mottu_marvel/app/characters/models/contents_model.dart';
import 'package:mottu_marvel/app/characters/models/thumbnail_model.dart';
import 'package:mottu_marvel/app/characters/repository/character_repository.dart';
import 'package:mottu_marvel/core/api/failure/failure.dart';
import 'package:mottu_marvel/core/connection/connection_service.dart';
import 'package:mottu_marvel/core/firebase/crashlytics_service.dart';

class MockCharacterRepository extends Mock implements CharacterRepository {}

class MockCharactersCache extends Mock implements CharactersCache {}

class MockConnectionService extends Mock implements ConnectionService {}

class MockCrashlyticsService extends Mock implements CrashlyticsService {}

void main() {
  late CharactersController controller;
  late MockCharacterRepository mockRepository;
  late MockCharactersCache mockCache;
  late MockConnectionService mockConnectionService;
  late MockCrashlyticsService mockCrashlytics;

  final selectedCharacter = CharacterModel(
    id: 1,
    name: 'Iron Man',
    description: '',
    thumbnail: ThumbnailModel(path: 'https://example.com/ironman', extension: 'jpg'),
    comics: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/comics/1', name: '')]),
    series: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/series/1', name: '')]),
    stories: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/stories/1', name: '')]),
    events: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/events/1', name: '')]),
  );

  final relatedCharacters = [
    CharacterModel(
      id: 2,
      name: 'Spider Man',
      description: '',
      thumbnail: ThumbnailModel(path: 'https://example.com/spiderman', extension: 'jpg'),
      comics: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/comics/1', name: '')]),
      series: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/series/1', name: '')]),
      stories: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/stories/1', name: '')]),
      events: Contents(items: [ContentsItem(resourceUri: 'http://gateway.marvel.com/v1/public/events/1', name: '')]),
    ),
  ];

  setUp(() {
    mockRepository = MockCharacterRepository();
    mockCache = MockCharactersCache();
    mockConnectionService = MockConnectionService();
    mockCrashlytics = MockCrashlyticsService();

    controller = CharactersController(
      repository: mockRepository,
      cache: mockCache,
      connectionService: mockConnectionService,
      crashlytics: mockCrashlytics,
    );

    registerFallbackValue(CharacterModel(
      id: 0,
      name: '',
      description: '',
      thumbnail: ThumbnailModel(path: '', extension: ''),
      comics: Contents(items: []),
      series: Contents(items: []),
      stories: Contents(items: []),
      events: Contents(items: []),
    ));
  });

  group('CharactersController Test', () {
    test('Load related characters from cache', () async {
      when(() => mockCache.getRelatedCharacters(1)).thenReturn(relatedCharacters);

      await controller.getRelatedCharacters(characterId: 1);

      expect(controller.relatedCharacters.length, 1);
      verify(() => mockCache.getRelatedCharacters(1)).called(1);
      expect(controller.status.isSuccess, true);
    });

    test('Load related characters from repository when not in cache', () async {
      when(() => mockCache.getRelatedCharacters(1)).thenReturn(null);
      when(() => mockRepository.getCharacterById(1)).thenAnswer((_) async => Right(selectedCharacter));
      when(() => mockRepository.getRelatedCharacters([1])).thenAnswer((_) async => Right(relatedCharacters));

      await controller.getRelatedCharacters(characterId: 1);

      expect(controller.relatedCharacters.length, 1);
      verify(() => mockCache.getRelatedCharacters(1)).called(1);
      verify(() => mockRepository.getRelatedCharacters([1])).called(1);
      expect(controller.status.isSuccess, true);
    });
  });

  test('Handle error when loading characters from repository', () async {
    when(() => mockCache.getAllCharacters()).thenReturn([]);
    when(() => mockRepository.getCharactersList(offset: 0, limit: 20)).thenAnswer((_) async => Left(Failure(message: 'Error loading characters')));

    await controller.getCharacters();

    expect(controller.characters.isEmpty, true);
    verify(() => mockRepository.getCharactersList(offset: 0, limit: 20)).called(1);
    expect(controller.status.isError, true);
    expect(controller.status.errorMessage, 'Error loading characters');
  });

  test('Handle error when loading related characters from repository', () async {
    when(() => mockCache.getRelatedCharacters(1)).thenReturn(null);
    when(() => mockRepository.getCharacterById(1)).thenAnswer((_) async => Right(selectedCharacter));
    when(() => mockRepository.getRelatedCharacters([1])).thenAnswer((_) async => Left(Failure(message: 'Error loading related characters')));

    await controller.getRelatedCharacters(characterId: 1);

    expect(controller.relatedCharacters.isEmpty, true);
    verify(() => mockRepository.getRelatedCharacters([1])).called(1);
    expect(controller.status.isError, true);
    expect(controller.status.errorMessage, 'Error loading related characters');
  });

  test('Loading status is set correctly when fetching characters', () async {
    when(() => mockCache.getAllCharacters()).thenReturn([]);
    when(() => mockRepository.getCharactersList(offset: 0, limit: 20)).thenAnswer(
      (_) async => Right([selectedCharacter]),
    );

    final future = controller.getCharacters();

    expect(controller.status.isLoading, true);

    await future;

    expect(controller.status.isSuccess, true);
    expect(controller.characters.length, 1);
  });
}
