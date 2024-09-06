import 'package:flutter/material.dart';

import '../../../../../styles/styles.dart';
import '../../../models/character_model.dart';

class CharacterItemCard extends StatelessWidget {
  const CharacterItemCard({
    super.key,
    required this.character,
  });

  final CharacterModel character;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'character ${character.id}',
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(character.thumbnail.fullPath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.6)),
          child: Text(
            character.name,
            textAlign: TextAlign.center,
            style: StylesFontStyles.subtitle,
          ),
        ),
      ),
    );
  }
}
