import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/chat_message.dart';
import '../../models/chat_thread.dart';
import '../../providers/chat_provider.dart';
import '../../providers/family_provider.dart';
import '../../widgets/empty_state.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final FamilyProvider familyProvider = context.watch<FamilyProvider>();

    if (chatProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<ChatThread> threads = chatProvider.threads;
    if (threads.isEmpty) {
      return Center(child: EmptyState(message: l10n.translate('noConversations')));
    }

    return SafeArea(
      child: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (BuildContext context, int index) {
          final ChatThread thread = threads[index];
          final List<ChatMessage> messages = chatProvider.messagesForThread(thread.id);
          final ChatMessage? lastMessage = messages.isNotEmpty ? messages.last : null;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(thread.isGroup ? Icons.group : Icons.person),
              title: Text(thread.title),
              subtitle: Text(lastMessage?.content ?? l10n.translate('addNew')),
              onTap: () => _showThread(context, thread, messages, familyProvider),
            ),
          );
        },
      ),
    );
  }

  void _showThread(
    BuildContext context,
    ChatThread thread,
    List<ChatMessage> messages,
    FamilyProvider familyProvider,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, ScrollController controller) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(thread.title, style: Theme.of(context).textTheme.titleMedium),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ChatMessage message = messages[index];
                      final displayName = familyProvider.members
                          .firstWhere(
                            (member) => member.id == message.senderId,
                            orElse: () => familyProvider.family.members.isNotEmpty
                                ? familyProvider.family.members.first
                                : familyProvider.members.first,
                          )
                          .displayName;
                      return ListTile(
                        title: Text(displayName),
                        subtitle: Text(message.content),
                        trailing: Text(
                          '${message.sentAt.hour.toString().padLeft(2, '0')}:${message.sentAt.minute.toString().padLeft(2, '0')}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
