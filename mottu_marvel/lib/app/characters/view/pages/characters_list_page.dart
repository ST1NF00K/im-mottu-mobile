import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/dependencies/setup_dependencies.dart';
import '../../controller/characters_list_controller.dart';
import 'character_details_page.dart';

class CharactersListView extends StatefulWidget {
  const CharactersListView({super.key});

  @override
  State<CharactersListView> createState() => _CharactersListViewState();
}

class _CharactersListViewState extends State<CharactersListView> {
  late final CharactersListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getIt.get<CharactersListController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),
      body: GetX<CharactersListController>(
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
                    leading: Image.network(character.thumbnail.fullPath),
                    title: Text(character.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailsView(character: character),
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
