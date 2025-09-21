import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../models/family_role.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.member,
    this.size = 48,
    this.onTap,
  });

  final FamilyMember member;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: member.avatarUrl == null
            ? Text(
                _initials(member.displayName),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
              )
            : null,
      ),
    );
  }

  String _initials(String name) {
    final List<String> parts = name.split(' ');
    if (parts.length == 1) {
      return name.characters.take(1).toString().toUpperCase();
    }
    return (parts.first.characters.take(1).toString() + parts.last.characters.take(1).toString()).toUpperCase();
  }
}

class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.role});

  final FamilyRole role;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(role.nameKey),
      visualDensity: VisualDensity.compact,
    );
  }
}
