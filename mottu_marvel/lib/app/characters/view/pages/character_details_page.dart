import 'package:flutter/material.dart';
import 'package:mottu_marvel/app/characters/view/pages/related_character_details_page.dart';
import 'package:mottu_marvel/design_system/tokens/spacings/inset_spacings.dart';
import 'package:mottu_marvel/design_system/tokens/spacings/stack_spacings.dart';
import '../../../../design_system/tokens/typography/text_styles.dart';
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
          style: StylesFontStyles.headline1,
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
            const SizedBox(height: StylesStackSpacings.xl),
            if (relatedCharacters.isNotEmpty)
              Text(
                "Personagens relacionados",
                style: StylesFontStyles.headline2,
              ),
            const SizedBox(height: StylesStackSpacings.l),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: relatedCharacters.length,
              itemBuilder: (context, index) {
                final character = relatedCharacters[index];
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
                          builder: (context) => RelatedCharacterDetailsPage(
                            character: character,
                          ),
                        ),
                      );
                    },
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
