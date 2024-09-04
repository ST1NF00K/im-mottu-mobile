import 'package:flutter/material.dart';
import 'package:mottu_marvel/design_system/styles/spacings/inset_spacings.dart';
import 'package:mottu_marvel/design_system/styles/spacings/stack_spacings.dart';
import '../../../../design_system/styles/typography/text_styles.dart';
import '../../models/character_model.dart';

class CharacterDetailsPage extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailsPage({
    super.key,
    required this.character,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              character.thumbnail.fullPath,
              height: 40,
            ),
            const SizedBox(height: StylesStackSpacings.m),
            Text(
              character.name,
              style: StylesFontStyles.title,
            ),
            const SizedBox(height: StylesStackSpacings.m),
            Text(
              character.description,
              style: StylesFontStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
