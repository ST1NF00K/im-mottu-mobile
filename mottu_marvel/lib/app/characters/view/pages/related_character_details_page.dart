import 'package:flutter/material.dart';
import 'package:mottu_marvel/design_system/tokens/spacings/inset_spacings.dart';
import 'package:mottu_marvel/design_system/tokens/spacings/stack_spacings.dart';
import '../../../../design_system/tokens/typography/text_styles.dart';
import '../../models/character_model.dart';

class RelatedCharacterDetailsPage extends StatelessWidget {
  final CharacterModel character;

  const RelatedCharacterDetailsPage({
    super.key,
    required this.character,
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
          ],
        ),
      ),
    );
  }
}
