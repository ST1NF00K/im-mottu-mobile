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
          ],
        ),
      ),
    );
  }
}
