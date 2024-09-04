import 'package:get/get.dart';
import '../models/character_model.dart';
import '../repository/character_repository.dart';

class CharactersListController extends GetxController with StateMixin<List<CharacterModel>> {
  final CharacterRepository _repository;

  CharactersListController({required CharacterRepository repository}) : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    getCharacters();
  }

  RxList<CharacterModel> characters = <CharacterModel>[].obs;
  RxList<CharacterModel> relatedCharacters = <CharacterModel>[].obs;
  Rxn<CharacterModel> selectedCharacter = Rxn<CharacterModel>();

  Future<void> getCharacters() async {
    change(null, status: RxStatus.loading());
    final response = await _repository.getCharactersList();
    response.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (success) {
        characters.value = success;
        change(success, status: RxStatus.success());
      },
    );
  }

  Future<void> filterCharactersByName({required String query}) async {
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
    selectedCharacter.value = null;
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
    //relatedCharacters.clear();
    await _getCharacterById(characterId);

    final character = selectedCharacter.value;

    if (character != null) {
      change(null, status: RxStatus.loading());

      final response = await _repository.getRelatedCharacters(
        character.getComicIds(),
        character.getSeriesIds(),
        character.getStoryIds(),
        character.getEventIds(),
      );
      response.fold(
        (failure) => change(null, status: RxStatus.error(failure.message)),
        (success) {
          relatedCharacters.value = success;
          change(success, status: RxStatus.success());
        },
      );
    }
  }
}
