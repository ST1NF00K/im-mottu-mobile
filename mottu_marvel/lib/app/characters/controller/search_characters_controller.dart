import 'package:get/get.dart';

class SearchCharactersController extends GetxController {
  var isSearching = false.obs;

  void startSearching() {
    isSearching.value = true;
  }

  void stopSearching() {
    isSearching.value = false;
  }
}
