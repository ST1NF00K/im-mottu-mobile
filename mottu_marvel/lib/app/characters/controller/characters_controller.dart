import 'dart:async';

import 'package:get/get.dart';
import '../../../core/connection/connection_service.dart';
import '../cache/caracters_cache.dart';
import '../models/character_model.dart';
import '../repository/character_repository.dart';

class CharactersController extends GetxController with StateMixin<List<CharacterModel>> {
  final CharacterRepository _repository;
  final CharactersCache _cache;
  final ConnectionService _connectionService;
  late StreamSubscription<bool> _connectionSubscription;

  CharactersController({
    required CharacterRepository repository,
    required CharactersCache cache,
    required ConnectionService connectionService,
  })  : _repository = repository,
        _cache = cache,
        _connectionService = connectionService;

  final RxBool _hasMore = true.obs;
  final RxInt _offset = 0.obs;
  final int _limit = 20;

  RxList<CharacterModel> characters = <CharacterModel>[].obs;
  RxList<CharacterModel> relatedCharacters = <CharacterModel>[].obs;
  Rxn<CharacterModel> selectedCharacter = Rxn<CharacterModel>();
  RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCharacters();

    _connectionSubscription = _connectionService.connectionStream.listen((bool connected) {
      isConnected.value = connected;
      if (!connected) {
        change(null, status: RxStatus.error('Sem conexão com a internet.'));
      } else {
        loadCharacters();
      }
    });
  }

  @override
  void onClose() {
    _connectionSubscription.cancel();
    super.onClose();
  }

  Future<void> loadCharacters() async {
    final cachedCharacters = _cache.getAllCharacters();
    if (cachedCharacters.isNotEmpty) {
      characters.value = cachedCharacters;
      change(cachedCharacters, status: RxStatus.success());
      _offset.value = cachedCharacters.length;
    } else if (isConnected.value) {
      await getCharacters();
    }
  }

  Future<void> getCharacters({bool isLoadMore = false}) async {
    if (!isLoadMore && !_hasMore.value) return;
    if (!isConnected.value) {
      change(null, status: RxStatus.error('Sem conexão com a internet.'));
      return;
    }

    change(null, status: RxStatus.loading());
    final response = await _repository.getCharactersList(
      offset: _offset.value,
      limit: _limit,
    );

    response.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (success) {
        if (success.isEmpty) {
          _hasMore.value = false;
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
  }

  Future<void> filterCharactersByName({required String query}) async {
    if (!isConnected.value) {
      change(null, status: RxStatus.error('Sem conexão com a internet.'));
      return;
    }

    change(null, status: RxStatus.loading());
    final response = await _repository.filterCharactersByName(
      query: query,
    );
    response.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (success) {
        characters.value = success;
        change(success, status: RxStatus.success());
      },
    );
  }

  Future<CharacterModel?> _getCharacterById(int characterId) async {
    if (!isConnected.value) {
      change(null, status: RxStatus.error('Sem conexão com a internet.'));
      return null;
    }

    change(null, status: RxStatus.loading());
    final response = await _repository.getCharacterById(characterId);
    response.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (success) {
        selectedCharacter.value = success;
        change(null, status: RxStatus.success());
      },
    );

    return selectedCharacter.value;
  }

  Future<void> getRelatedCharacters({required int characterId}) async {
    if (!isConnected.value) {
      change(null, status: RxStatus.error('Sem conexão com a internet.'));
      return;
    }

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
          (failure) => change(null, status: RxStatus.error(failure.message)),
          (success) {
            relatedCharacters.value = success;
            _cache.addRelatedCharacters(characterId, success);
            change(success, status: RxStatus.success());
          },
        );
      }
    }
  }

  Future<void> loadMoreCharacters() async {
    if (_hasMore.value) {
      await getCharacters(isLoadMore: true);
    }
  }
}
