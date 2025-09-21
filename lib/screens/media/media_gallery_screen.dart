import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/media_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/media_tile.dart';
import '../../widgets/section_header.dart';

class MediaGalleryScreen extends StatelessWidget {
  const MediaGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final MediaProvider mediaProvider = context.watch<MediaProvider>();

    if (mediaProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool hasMedia = mediaProvider.items.isNotEmpty;

    return SafeArea(
      child: ListView(
        children: <Widget>[
          SectionHeader(title: l10n.translate('moduleMedia')),
          if (!hasMedia)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...mediaProvider.items.map((item) => MediaTile(mediaItem: item)),
          SectionHeader(title: l10n.translate('recommendedActions'), actionLabel: l10n.translate('addNew'), onActionPressed: () {
            mediaProvider.refreshRecommendations();
          }),
          if (mediaProvider.recommendations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...mediaProvider.recommendations.map(
              (recommendation) => ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(recommendation.title),
                subtitle: Text(recommendation.description),
              ),
            ),
        ],
      ),
    );
  }
}
