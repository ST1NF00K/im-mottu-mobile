import 'package:flutter/material.dart';

import '../styles.dart';

class CharacterDetailsWidget extends StatelessWidget {
  const CharacterDetailsWidget({
    super.key,
    required this.imageUrl,
    required this.description,
    this.noDescriptionMessage,
  });

  final String imageUrl;
  final String description;
  final String? noDescriptionMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          imageUrl,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: StylesStackSpacings.l),
        Text(
          description.isNotEmpty ? description : noDescriptionMessage ?? 'Esse personagem não tem descrição.',
          style: StylesFontStyles.description,
        ),
      ],
    );
  }
}
