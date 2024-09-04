import 'dart:async';
import 'package:flutter/services.dart';

class ConnectionService {
  static const EventChannel _eventChannel = EventChannel('com.mottu.marvel/connectivity');

  late final Stream<bool> _connectionStream;

  ConnectionService() {
    _connectionStream = _eventChannel.receiveBroadcastStream().map((dynamic event) {
      return event as bool;
    });
  }

  Stream<bool> get connectionStream => _connectionStream;
}
