// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mottu_marvel/core/connection/connection_controller.dart';

import '../../../../core/dependencies/setup_dependencies.dart';
import '../../../../styles/styles.dart';
import '../../controller/characters_controller.dart';
import '../../controller/search_characters_controller.dart';
import 'components/characters_grid_view.dart';
import 'components/characters_page_header.dart';

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
            CharactersPageHeader(
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
                    return CharactersGridView(
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
