import 'package:flutter/services.dart';

class ConnectionService {
  static const _methodChannel = MethodChannel('com.mottu.marvel/connectivity');

  Future<String> getConnectivityStatus() async {
    try {
      final String connectivityStatus = await _methodChannel.invokeMethod('getConnectivityStatus');
      return connectivityStatus;
    } on PlatformException catch (e) {
      return 'Falha ao obter status de conectividade: ${e.message}';
    }
  }
}
