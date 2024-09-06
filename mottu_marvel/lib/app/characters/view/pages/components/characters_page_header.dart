import 'package:flutter/material.dart';

import '../../../../../styles/styles.dart';
import '../../../controller/characters_controller.dart';
import '../../../controller/search_characters_controller.dart';
import 'characters_search_field.dart';

class CharactersPageHeader extends StatelessWidget {
  const CharactersPageHeader({
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        image: const DecorationImage(
          image: AssetImage('lib/styles/assets/header_home.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment(-2.5, 0),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: StylesInsetSpacings.m,
        vertical: StylesInsetSpacings.s,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: StylesStackSpacings.m),
            SizedBox(
              width: 240,
              child: Text(
                'Descubra mais sobre seu herói favorito!',
                style: StylesFontStyles.header,
              ),
            ),
            const SizedBox(height: StylesStackSpacings.xxl),
            CharactersListSearchField(
              searchController: _searchController,
              controller: _controller,
              textEditingController: _textEditingController,
            ),
          ],
        ),
      ),
    );
  }
}
