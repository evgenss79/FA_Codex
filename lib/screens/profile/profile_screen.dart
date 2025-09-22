import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/family_member.dart';
import '../../models/family_role.dart';
import '../../providers/family_provider.dart';
import '../../widgets/member_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final FamilyProvider familyProvider = context.watch<FamilyProvider>();
    final List<FamilyMember> members = familyProvider.members;

    return SafeArea(
      child: ListView.builder(
        itemCount: members.length,
        itemBuilder: (BuildContext context, int index) {
          final FamilyMember member = members[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              leading: MemberAvatar(member: member),
              title: Text(member.displayName),
              subtitle: Text(l10n.translate(member.role.nameKey)),
              children: <Widget>[
                if (member.bio != null)
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(member.bio!),
                  ),
                ListTile(
                  leading: const Icon(Icons.star_outline),
                  title: Text('${l10n.translate('totalPoints')}: ${member.rewards}'),
                ),
                if (member.interests.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.favorite_outline),
                    title: Text(member.interests.join(', ')),
                  ),
                if (member.socialLinks.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.link_outlined),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: member.socialLinks.entries
                          .map((entry) => Text('${entry.key}: ${entry.value}'))
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
