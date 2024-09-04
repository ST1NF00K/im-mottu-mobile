import 'package:get/get.dart';
import '../../../core/firebase/crashlytics_service.dart';
import '../cache/caracters_cache.dart';
import '../models/character_model.dart';
import '../repository/character_repository.dart';

class CharactersController extends GetxController with StateMixin<List<CharacterModel>> {
  final CharacterRepository _repository;
  final CharactersCache _cache;
  final CrashlyticsService _crashlytics;

  CharactersController({
    required CharacterRepository repository,
    required CharactersCache cache,
    required CrashlyticsService crashlytics,
  })  : _repository = repository,
        _cache = cache,
        _crashlytics = crashlytics;

  RxString searchQuery = ''.obs;
  final RxBool hasMore = true.obs;
  RxInt _offset = 0.obs;
  final int _limit = 20;

  RxList<CharacterModel> characters = <CharacterModel>[].obs;
  RxList<CharacterModel> relatedCharacters = <CharacterModel>[].obs;
  Rxn<CharacterModel> selectedCharacter = Rxn<CharacterModel>();

  @override
  void onInit() {
    super.onInit();
    loadCharacters();
  }

  void resetOffset() {
    _offset = 0.obs;
  }

  void updateSearchQuery(String query) {
    searchQuery = query.obs;
  }

  Future<void> loadCharacters() async {
    try {
      final cachedCharacters = _cache.getAllCharacters();
      if (cachedCharacters.isNotEmpty) {
        characters.value = cachedCharacters;
        change(cachedCharacters, status: RxStatus.success());
        _offset.value = cachedCharacters.length;
      } else {
        await getCharacters();
      }
    } catch (e, stack) {
      _crashlytics.recordError(e, stack);
      change(null, status: RxStatus.error('Erro ao carregar personagens.'));
    }
  }

  Future<void> getCharacters({bool isLoadMore = false}) async {
    if (!isLoadMore && !hasMore.value) return;

    try {
      change(null, status: RxStatus.loading());
      final response = await _repository.getCharactersList(
        offset: _offset.value,
        limit: _limit,
      );

      response.fold(
        (failure) {
          _crashlytics.log('Falha ao obter lista de personagens: ${failure.message}');
          change(null, status: RxStatus.error(failure.message));
        },
        (success) {
          if (success.isEmpty) {
            hasMore.value = false;
          } else {
            if (isLoadMore) {
              characters.addAll(success);
            } else {
              characters.value = success;
            }
            _offset.value += success.length;
            _cache.clear();
            for (var character in success) {
              _cache.addData(character);
            }
            change(success, status: RxStatus.success());
          }
        },
      );
    } catch (e, stack) {
      _crashlytics.recordError(e, stack);
      change(null, status: RxStatus.error('Erro ao obter personagens.'));
    }
  }

  Future<void> filterCharactersByName() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _repository.filterCharactersByName(
        query: searchQuery.value,
      );
      response.fold(
        (failure) {
          _crashlytics.log('Erro ao filtrar personagens: ${failure.message}');
          change(null, status: RxStatus.error(failure.message));
        },
        (success) {
          characters.value = success;
          change(success, status: RxStatus.success());
        },
      );
    } catch (e, stack) {
      _crashlytics.recordError(e, stack);
      change(null, status: RxStatus.error('Erro ao filtrar personagens.'));
    }
  }

  Future<CharacterModel?> _getCharacterById(int characterId) async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _repository.getCharacterById(characterId);
      response.fold(
        (failure) {
          _crashlytics.log('Erro ao buscar personagem com ID: $characterId');
          change(null, status: RxStatus.error(failure.message));
        },
        (success) {
          selectedCharacter.value = success;
          change(null, status: RxStatus.success());
        },
      );
      return selectedCharacter.value;
    } catch (e, stack) {
      _crashlytics.recordError(e, stack);
      change(null, status: RxStatus.error('Erro ao buscar personagem.'));
      return null;
    }
  }

  Future<void> getRelatedCharacters({required int characterId}) async {
    try {
      final cachedRelatedCharacters = _cache.getRelatedCharacters(characterId);

      if (cachedRelatedCharacters != null) {
        relatedCharacters.value = cachedRelatedCharacters;
        change(cachedRelatedCharacters, status: RxStatus.success());
      } else {
        await _getCharacterById(characterId);

        final character = selectedCharacter.value;

        if (character != null) {
          change(null, status: RxStatus.loading());

          final response = await _repository.getRelatedCharacters(
            character.getComicIds(),
          );
          response.fold(
            (failure) {
              _crashlytics.log('Erro ao buscar personagens relacionados para ID: $characterId');
              change(null, status: RxStatus.error(failure.message));
            },
            (success) {
              relatedCharacters.value = success;
              _cache.addRelatedCharacters(characterId, success);
              change(success, status: RxStatus.success());
            },
          );
        }
      }
    } catch (e, stack) {
      _crashlytics.recordError(e, stack);
      change(null, status: RxStatus.error('Erro ao buscar personagens relacionados.'));
    }
  }

  Future<void> loadMoreCharacters() async {
    if (hasMore.value) {
      await getCharacters(isLoadMore: true);
    }
  }
}
