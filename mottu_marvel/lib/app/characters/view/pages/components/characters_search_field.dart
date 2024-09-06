import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../styles/styles.dart';
import '../../../controller/characters_controller.dart';
import '../../../controller/search_characters_controller.dart';

class CharactersListSearchField extends StatelessWidget {
  const CharactersListSearchField({
    super.key,
    required SearchCharactersController searchController,
    required CharactersController controller,
    required TextEditingController textEditingController,
  })  : _searchController = searchController,
        _controller = controller,
        _textEditingController = textEditingController;

  final SearchCharactersController _searchController;
  final CharactersController _controller;
  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextField(
        controller: _textEditingController,
        style: const TextStyle(color: Colors.black45),
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          contentPadding: const EdgeInsets.all(StylesInsetSpacings.m),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: _searchController.isSearching.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _textEditingController.clear();
                    _searchController.stopSearching();
                    _controller.updateSearchQuery('');
                    _controller.resetOffset();
                    _controller.getCharacters();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _searchController.startSearching();
            _controller.updateSearchQuery(value);
            _controller.filterCharactersByName();
          } else {
            _searchController.stopSearching();
            _controller.resetOffset();
            _controller.getCharacters();
          }
        },
      );
    });
  }
}
