// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mottu_marvel/core/connection/connection_controller.dart';
import 'package:mottu_marvel/styles/tokens/spacings/stack_spacings.dart';

import '../../../../core/connection/connection_service.dart';
import '../../../../core/dependencies/setup_dependencies.dart';
import '../../../../styles/tokens/spacings/inset_spacings.dart';
import '../../../../styles/tokens/typography/font_styles.dart';
import '../../controller/characters_controller.dart';
import '../../controller/search_characters_controller.dart';
import '../../models/character_model.dart';
import 'character_details_page.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  late final CharactersController _controller;
  late final SearchCharactersController _searchController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late final ConnectionController _connectionController;

  @override
  void initState() {
    super.initState();

    _connectionController = getIt.get<ConnectionController>()..startCheckingConnection();

    _controller = getIt.get<CharactersController>()..loadCharacters();
    _searchController = getIt.get<SearchCharactersController>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _controller.loadMoreCharacters();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CharactersPageHeader(
              searchController: _searchController,
              controller: _controller,
              textEditingController: _textEditingController,
            ),
            Obx(() {
              if (Platform.isAndroid) {
                var status = _connectionController.connectionStatus.value;
                String message = status == 'none' ? 'Você está offine!' : 'Você está conectado!';

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message,
                        style: StylesFontStyles.snackbar,
                      ),
                      backgroundColor: status == 'none' ? Colors.red : Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                });
              }
              return const SizedBox.shrink();
            }),
            Expanded(
              child: GetBuilder<CharactersController>(
                init: _controller,
                builder: (controller) {
                  if (controller.status.isLoading && controller.characters.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.status.isError) {
                    return const Center(child: Text('Ocorreu um erro ao carregar a lista de personagens.'));
                  } else if (controller.status.isSuccess || controller.characters.isNotEmpty) {
                    final characters = controller.characters;
                    return _CharactersGridView(
                      scrollController: _scrollController,
                      characters: characters,
                      controller: controller,
                    );
                  }
                  return const Center(child: Text('A lista de personagens está vazia.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharactersGridView extends StatelessWidget {
  const _CharactersGridView({
    required ScrollController scrollController,
    required this.characters,
    required this.controller,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<CharacterModel> characters;
  final CharactersController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: StylesInsetSpacings.m,
        mainAxisSpacing: StylesInsetSpacings.m,
      ),
      padding: const EdgeInsets.all(StylesInsetSpacings.m),
      itemCount: characters.length + (controller.isLoadingMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == characters.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(StylesInsetSpacings.m),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final character = characters[index];
        return InkWell(
          onTap: () {
            controller.getRelatedCharacters(characterId: character.id).then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterDetailsPage(
                    character: character,
                    relatedCharacters: controller.relatedCharacters,
                  ),
                ),
              );
            });
          },
          child: _CharacterItemCard(character: character),
        );
      },
    );
  }
}

class _CharactersPageHeader extends StatelessWidget {
  const _CharactersPageHeader({
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
            _CharactersListSearchField(
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

class _CharacterItemCard extends StatelessWidget {
  const _CharacterItemCard({
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

class _CharactersListSearchField extends StatelessWidget {
  const _CharactersListSearchField({
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
