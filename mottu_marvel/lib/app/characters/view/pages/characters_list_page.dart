import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mottu_marvel/design_system/tokens/spacings/stack_spacings.dart';

import '../../../../core/dependencies/setup_dependencies.dart';
import '../../../../design_system/tokens/spacings/inset_spacings.dart';
import '../../../../design_system/tokens/typography/text_styles.dart';
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

  @override
  void initState() {
    super.initState();

    _controller = getIt.get<CharactersController>()..loadCharacters();
    _searchController = getIt.get<SearchCharactersController>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _controller.loadMoreCharacters();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.loadCharacters();
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
            _buildHeader(),
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
                    return _buildCharacterGrid(characters, controller);
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

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        image: const DecorationImage(
          image: AssetImage('lib/design_system/assets/header_home.jpg'),
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
            _buildSearchField(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Obx(() {
      return TextField(
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
                    _searchController.stopSearching();
                    _controller.resetOffset();
                    _controller.getCharacters();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _searchController.startSearching();
            _controller.filterCharactersByName(query: value);
          } else {
            _searchController.stopSearching();
            _controller.resetOffset();
            _controller.getCharacters();
          }
        },
      );
    });
  }

  Widget _buildCharacterGrid(
    List<CharacterModel> characters,
    CharactersController controller,
  ) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: StylesInsetSpacings.m,
        mainAxisSpacing: StylesInsetSpacings.m,
      ),
      padding: const EdgeInsets.all(StylesInsetSpacings.m),
      itemCount: characters.length,
      itemBuilder: (context, index) {
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
          child: Hero(
            tag: 'character $index',
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
          ),
        );
      },
    );
  }
}
