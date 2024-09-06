import 'dart:async';
import 'package:get/get.dart';
import 'connection_service.dart';

class ConnectionController extends GetxController {
  final ConnectionService _connectionService;

  RxString connectionStatus = 'none'.obs;

  ConnectionController({required ConnectionService connectionService}) : _connectionService = connectionService;

  @override
  void onInit() {
    super.onInit();
    startCheckingConnection();
  }

  void startCheckingConnection() {
    _checkConnection();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkConnection();
    });
  }

  Future<void> _checkConnection() async {
    String status = await _connectionService.getConnectivityStatus();
    connectionStatus.value = status;
  }
}
