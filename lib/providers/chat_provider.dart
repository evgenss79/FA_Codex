import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../models/chat_thread.dart';
import '../models/family_member.dart';
import '../services/communication_service.dart';
import '../services/local_storage_service.dart';
import 'family_provider.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider({
    required this.storageService,
    required this.communicationService,
  }) {
    _load();
  }

  final LocalStorageService storageService;
  final CommunicationService communicationService;
  final Uuid _uuid = const Uuid();

  List<ChatThread> _threads = <ChatThread>[];
  final Map<String, List<ChatMessage>> _messages = <String, List<ChatMessage>>{};
  bool _loading = true;
  FamilyProvider? _familyProvider;

  List<ChatThread> get threads => _threads;

  bool get isLoading => _loading;

  void attachFamilyProvider(FamilyProvider familyProvider) {
    _familyProvider = familyProvider;
    _seedIfNeeded();
  }

  Future<void> _load() async {
    _threads = await storageService.loadChatThreads();
    final Map<String, List<ChatMessage>> storedMessages =
        await storageService.loadChatMessages();
    _messages
      ..clear()
      ..addAll(storedMessages);
    _loading = false;
    notifyListeners();
  }

  Future<void> _seedIfNeeded() async {
    if (_threads.isNotEmpty || _familyProvider == null) {
      return;
    }

    final _SeedData? seeded = _createSampleData(_familyProvider!.members);
    if (seeded == null) {
      return;
    }

    _threads = seeded.threads;
    _messages
      ..clear()
      ..addAll(seeded.messages);
    await _persist();
    notifyListeners();
  }

  _SeedData? _createSampleData(List<FamilyMember> members) {
    if (members.length < 2) {
      return null;
    }

    final String conversationId = _uuid.v4();
    final ChatThread thread = ChatThread(
      id: conversationId,
      title: 'Family chat',
      memberIds: members.map((FamilyMember m) => m.id).toList(),
      isGroup: true,
      updatedAt: DateTime.now(),
    );

    final List<ChatMessage> sampleMessages = <ChatMessage>[
      ChatMessage(
        id: _uuid.v4(),
        conversationId: conversationId,
        senderId: members.first.id,
        content: 'Hi team, remember the family dinner tomorrow!',
        sentAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ChatMessage(
        id: _uuid.v4(),
        conversationId: conversationId,
        senderId: members[1].id,
        content: 'Got it! I\'ll bring dessert.',
        sentAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
      ),
    ];

    return _SeedData(
      threads: <ChatThread>[thread],
      messages: <String, List<ChatMessage>>{conversationId: sampleMessages},
    );
  }

  Future<void> _persist() async {
    await storageService.saveChatThreads(_threads);
    await storageService.saveChatMessages(_messages);
  }

  List<ChatMessage> messagesForThread(String threadId) {
    return _messages[threadId] ?? <ChatMessage>[];
  }

  Future<ChatThread> createThread({
    required String title,
    required List<String> memberIds,
    bool isGroup = false,
    String? avatarUrl,
  }) async {
    final ChatThread thread = ChatThread(
      id: _uuid.v4(),
      title: title,
      memberIds: memberIds,
      isGroup: isGroup,
      avatarUrl: avatarUrl,
      updatedAt: DateTime.now(),
    );
    _threads = List<ChatThread>.from(_threads)..add(thread);
    _messages[thread.id] = <ChatMessage>[];
    await _persist();
    notifyListeners();
    return thread;
  }

  Future<ChatMessage> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
  }) async {
    final ChatMessage message = ChatMessage(
      id: _uuid.v4(),
      conversationId: threadId,
      senderId: senderId,
      content: content,
      sentAt: DateTime.now(),
      type: type,
      mediaUrl: mediaUrl,
    );

    final List<ChatMessage> updated = List<ChatMessage>.from(messagesForThread(threadId))
      ..add(message);
    _messages[threadId] = updated;

    final int threadIndex = _threads.indexWhere((ChatThread t) => t.id == threadId);
    if (threadIndex != -1) {
      _threads[threadIndex] = _threads[threadIndex].copyWith(
        lastMessage: content,
        updatedAt: message.sentAt,
      );
    }

    await _persist();
    await communicationService.sendMessage(message);
    notifyListeners();
    return message;
  }

  Future<void> markThreadAsRead(String threadId) async {
    final List<ChatMessage> updated = messagesForThread(threadId)
        .map((ChatMessage message) => message.copyWith(isRead: true))
        .toList();
    _messages[threadId] = updated;
    await storageService.saveChatMessages(_messages);
    notifyListeners();
  }

  Future<void> addReaction({
    required String threadId,
    required String messageId,
    required String emoji,
    required String memberId,
  }) async {
    final List<ChatMessage> threadMessages = messagesForThread(threadId);
    final int index = threadMessages.indexWhere((ChatMessage m) => m.id == messageId);
    if (index == -1) {
      return;
    }

    final ChatMessage target = threadMessages[index];
    final Map<String, List<String>> reactions = Map<String, List<String>>.from(target.reactions);
    final List<String> updatedUsers = List<String>.from(reactions[emoji] ?? <String>[]);
    if (updatedUsers.contains(memberId)) {
      updatedUsers.remove(memberId);
    } else {
      updatedUsers.add(memberId);
    }
    reactions[emoji] = updatedUsers;

    final ChatMessage updatedMessage = target.copyWith(reactions: reactions);
    threadMessages[index] = updatedMessage;
    _messages[threadId] = threadMessages;
    await _persist();
    notifyListeners();
  }
}

class _SeedData {
  const _SeedData({required this.threads, required this.messages});

  final List<ChatThread> threads;
  final Map<String, List<ChatMessage>> messages;
}
