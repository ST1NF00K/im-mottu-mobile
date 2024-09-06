// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../../styles/styles.dart';
import '../../../controller/characters_controller.dart';
import '../../../models/character_model.dart';
import '../character_details_page.dart';
import 'character_item_card.dart';

class CharactersGridView extends StatelessWidget {
  const CharactersGridView({
    super.key,
    required ScrollController scrollController,
    required this.characters,
    required this.controller,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<CharacterModel> characters;
  final CharactersController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: StylesInsetSpacings.m,
        mainAxisSpacing: StylesInsetSpacings.m,
      ),
      padding: const EdgeInsets.all(StylesInsetSpacings.m),
      itemCount: characters.length + (controller.isLoadingMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == characters.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(StylesInsetSpacings.m),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final character = characters[index];
        return InkWell(
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
          child: CharacterItemCard(character: character),
        );
      },
    );
  }
}
