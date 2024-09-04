import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/dependencies/setup_dependencies.dart';
import '../../../../design_system/styles/typography/text_styles.dart';
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GetBuilder<CharactersController>(
        init: _controller,
        builder: (controller) {
          if (controller.status.isLoading && controller.characters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.status.isError) {
            return const Center(child: Text('Ocorreu um erro ao carregar a lista de personagens.'));
          } else if (controller.status.isSuccess || controller.characters.isNotEmpty) {
            final characters = controller.characters;
            return _buildCharacterList(characters, controller);
          }
          return const Center(child: Text('A lista de personagens está vazia.'));
        },
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
