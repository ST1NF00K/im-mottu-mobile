import 'package:flutter/material.dart';
import '../../../../design_system/styles/typography/text_styles.dart';
import '../../models/character_model.dart';

class CharacterDetailsView extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailsView({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(character.thumbnail.fullPath),
            const SizedBox(height: 16),
            Text(
              character.name,
              style: StylesFontStyles.title,
            ),
            const SizedBox(height: 16),
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
