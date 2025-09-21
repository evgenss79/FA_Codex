import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/location_point.dart';
import '../../providers/family_provider.dart';
import '../../providers/media_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final FamilyProvider familyProvider = context.watch<FamilyProvider>();
    final MediaProvider mediaProvider = context.watch<MediaProvider>();

    final List<String> friends = familyProvider.family.friends;
    final List<LocationPoint> locations = familyProvider.favoriteLocations;

    return SafeArea(
      child: ListView(
        children: <Widget>[
          SectionHeader(title: l10n.translate('friendsFamilies')),
          if (friends.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...friends.map(
              (String friendId) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.family_restroom),
                  title: Text('Family $friendId'),
                  subtitle: const Text('Shared events, photos and recommendations'),
                ),
              ),
            ),
          SectionHeader(title: l10n.translate('geoPlaces')),
          if (locations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...locations.map(
              (LocationPoint location) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: Text(location.title),
                  subtitle: Text(location.address ?? ''),
                ),
              ),
            ),
          SectionHeader(title: l10n.translate('mediaHighlights')),
          if (mediaProvider.recommendations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...mediaProvider.recommendations.map(
              (recommendation) => ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text(recommendation.title),
                subtitle: Text(recommendation.description),
              ),
            ),
        ],
      ),
    );
  }
}
