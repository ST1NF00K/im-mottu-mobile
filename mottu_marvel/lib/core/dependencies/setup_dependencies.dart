import 'package:get_it/get_it.dart';
import '../../app/characters/cache/caracters_cache.dart';
import '../../app/characters/controller/characters_controller.dart';
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

  getIt.registerLazySingleton<CharactersCache>(
    () => CharactersCache(),
  );

  getIt.registerFactory<CharactersController>(
    () => CharactersController(
      repository: getIt.get<CharacterRepository>(),
      cache: getIt.get<CharactersCache>(),
    ),
  );

  getIt.registerFactory<SearchCharactersController>(
    () => SearchCharactersController(),
  );
}
