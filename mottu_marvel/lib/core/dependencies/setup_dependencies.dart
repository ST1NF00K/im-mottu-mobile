import 'package:get_it/get_it.dart';
import '../../app/characters/controller/characters_list_controller.dart';
import '../../app/characters/controller/search_characters_controller.dart';
import '../../app/characters/repository/character_repository.dart';
import '../api/http_service/dio/dio_http_service.dart';
import '../api/http_service/http_service.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<HttpService>(
    () => DioHttpService(),
  );

  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepository(
      http: getIt.get<HttpService>(),
    ),
  );

  getIt.registerFactory<CharactersListController>(
    () => CharactersListController(
      repository: getIt.get<CharacterRepository>(),
    ),
  );

  getIt.registerFactory<SearchCharactersController>(
    () => SearchCharactersController(),
  );
}
