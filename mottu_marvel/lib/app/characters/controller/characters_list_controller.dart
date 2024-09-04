import 'package:get/get.dart';
import '../models/character_model.dart';
import '../repository/character_repository.dart';

class CharactersListController extends GetxController with StateMixin<List<CharacterModel>> {
  final CharacterRepository _repository;

  CharactersListController({required CharacterRepository repository}) : _repository = repository;

  Future<void> getCharacters() async {
    change(null, status: RxStatus.loading());
    final response = await _repository.getCharactersList();
    response.fold(
      (failure) => change(null, status: RxStatus.error(failure.message)),
      (success) => change(success, status: RxStatus.success()),
    );
  }
}
