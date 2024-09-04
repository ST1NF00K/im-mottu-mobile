import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/dependencies/setup_dependencies.dart';
import '../../../../design_system/tokens/typography/text_styles.dart';
import '../../controller/characters_controller.dart';
import '../../controller/search_characters_controller.dart';
import '../../models/character_model.dart';
import 'character_details_page.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  late final CharactersController _controller;
  late final SearchCharactersController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller = getIt.get<CharactersController>()..loadCharacters();
    _searchController = getIt.get<SearchCharactersController>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _controller.loadMoreCharacters();
      }
    });

    if (Platform.isAndroid) {
      _controller.isConnected.listen((isConnected) {
        if (!isConnected) {
          Get.snackbar(
            'Sem conexão',
            'Você está desconectado da internet.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<CharactersController>(
              init: _controller,
              builder: (controller) {
                if (controller.status.isLoading && controller.characters.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.status.isError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.status.errorMessage ?? 'Ocorreu um erro ao carregar os personagens.',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _controller.loadCharacters,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.status.isSuccess || controller.characters.isNotEmpty) {
                  final characters = controller.characters;
                  return _buildCharacterList(characters, controller);
                }

                return const Center(child: Text('A lista de personagens está vazia.'));
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() {
        if (_searchController.isSearching.value) {
          return _buildSearchField();
        } else {
          return Text(
            'Personagens',
            style: StylesFontStyles.headline1,
          );
        }
      }),
      actions: [
        Obx(() {
          if (!_searchController.isSearching.value) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _searchController.startSearching();
              },
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Pesquisar...',
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _searchController.stopSearching();
            _controller.getCharacters();
          },
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          _searchController.startSearching();
          _controller.filterCharactersByName(query: value);
        } else {
          _searchController.stopSearching();
          _controller.getCharacters();
        }
      },
    );
  }

  Widget _buildCharacterList(
    List<CharacterModel> characters,
    CharactersController controller,
  ) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];

        return Card(
          child: ListTile(
            leading: Image.network(
              character.thumbnail.fullPath,
              fit: BoxFit.fitHeight,
              width: 60,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red, size: 60);
              },
            ),
            title: Text(character.name),
            onTap: () {
              controller.getRelatedCharacters(characterId: character.id).then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharacterDetailsPage(
                      character: character,
                      relatedCharacters: controller.relatedCharacters,
                    ),
                  ),
                );
              });
            },
          ),
        );
      },
    );
  }
}
