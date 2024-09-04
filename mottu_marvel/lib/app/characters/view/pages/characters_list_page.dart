import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/dependencies/setup_dependencies.dart';
import '../../controller/characters_list_controller.dart';
import '../../controller/search_characters_controller.dart';
import 'character_details_page.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  late final CharactersListController _controller;
  late final SearchCharactersController _searchController;

  @override
  void initState() {
    super.initState();
    _controller = getIt.get<CharactersListController>();
    _searchController = getIt.get<SearchCharactersController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (_searchController.isSearching.value) {
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
                if (value != '') {
                  _searchController.startSearching();
                  _controller.filterCharactersByName(query: value);
                } else {
                  _searchController.stopSearching();
                  _controller.getCharacters();
                }
              },
            );
          } else {
            return const Text('Personagens');
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
      ),
      body: GetBuilder<CharactersListController>(
        init: _controller,
        builder: (controller) {
          if (controller.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.status.isError) {
            return const Center(child: Text('Ocorreu um erro ao carregar a lista de personagens.'));
          } else if (controller.status.isSuccess) {
            final characters = controller.state ?? [];
            return ListView.builder(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailsPage(character: character),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('A lista de personagens está vazia.'));
        },
      ),
    );
  }
}
