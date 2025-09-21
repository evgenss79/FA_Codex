import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';

class CommunicationService {
  final StreamController<ChatMessage> _incomingMessagesController =
      StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get incomingMessages => _incomingMessagesController.stream;

  Future<void> sendMessage(ChatMessage message) async {
    debugPrint('Sending message: ${message.content}');
  }

  Future<void> simulateIncomingMessage(ChatMessage message) async {
    _incomingMessagesController.add(message);
  }

  Future<void> startVoiceCall(List<String> participantIds) async {
    debugPrint('Starting voice call with $participantIds');
  }

  Future<void> startVideoCall(List<String> participantIds) async {
    debugPrint('Starting video call with $participantIds');
  }

  Future<void> dispose() async {
    await _incomingMessagesController.close();
  }
}
