import 'package:flutter/material.dart';
import 'package:mottu_marvel/design_system/styles/spacings/inset_spacings.dart';
import 'package:mottu_marvel/design_system/styles/spacings/stack_spacings.dart';
import '../../../../design_system/styles/typography/text_styles.dart';
import '../../models/character_model.dart';

class CharacterDetailsPage extends StatelessWidget {
  final CharacterModel character;
  final List<CharacterModel> relatedCharacters;

  const CharacterDetailsPage({
    super.key,
    required this.character,
    required this.relatedCharacters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          character.name,
          style: StylesFontStyles.headline2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(StylesInsetSpacings.m),
        child: ListView(
          children: [
            Image.network(
              character.thumbnail.fullPath,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: StylesStackSpacings.l),
            Text(
              character.description,
              style: StylesFontStyles.subtitle,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: relatedCharacters.length,
              itemBuilder: (context, index) {
                final character = relatedCharacters[index];
                return ListTile(
                  title: Text(
                    character.name,
                    style: StylesFontStyles.subtitle,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
