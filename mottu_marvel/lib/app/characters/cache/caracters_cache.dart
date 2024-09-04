import 'package:get/utils.dart';
import '../models/character_model.dart';

class CharactersCache {
  final List<CharacterModel> _data = [];
  final Map<int, List<CharacterModel>> _relatedCharactersCache = {};

  void addData(CharacterModel data) {
    _data.add(data);
  }

  void removeData(CharacterModel data) {
    _data.remove(data);
  }

  void clear() {
    _data.clear();
    _relatedCharactersCache.clear();
  }

  List<CharacterModel> getAllCharacters() => _data;

  CharacterModel? getCharacterById(int id) => _data.firstWhereOrNull((character) => character.id == id);

  void addRelatedCharacters(int characterId, List<CharacterModel> relatedCharacters) {
    _relatedCharactersCache[characterId] = relatedCharacters;
  }

  List<CharacterModel>? getRelatedCharacters(int characterId) => _relatedCharactersCache[characterId];
}
