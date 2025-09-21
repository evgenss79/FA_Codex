import 'package:collection/collection.dart';

import '../models/ai_recommendation.dart';
import '../models/family_member.dart';
import '../models/media_item.dart';
import '../models/task.dart';

class AiAssistantService {
  Future<List<AiRecommendation>> generateMediaHighlights({
    required List<FamilyMember> members,
    required List<MediaItem> media,
  }) async {
    if (media.isEmpty) {
      return <AiRecommendation>[];
    }

    final MediaItem? latest = media.sorted((MediaItem a, MediaItem b) => b.createdAt.compareTo(a.createdAt)).firstOrNull;
    final List<AiRecommendation> recommendations = <AiRecommendation>[];

    if (latest != null) {
      final FamilyMember? owner =
          members.firstWhereOrNull((FamilyMember member) => member.id == latest.ownerId);
      recommendations.add(
        AiRecommendation(
          id: 'media-highlight-${latest.id}',
          title: 'Share recent memory',
          description:
              'Celebrate ${owner?.displayName ?? 'a family member'}\'s moment: "${latest.caption ?? 'New memory'}"',
          category: 'memories',
          link: latest.url,
          metadata: <String, dynamic>{
            'ownerId': latest.ownerId,
            'createdAt': latest.createdAt.toIso8601String(),
          },
        ),
      );
    }

    final Map<String, List<MediaItem>> mediaByOwner = groupBy<MediaItem, String>(
      media,
      (MediaItem item) => item.ownerId,
    );

    final Iterable<MapEntry<String, List<MediaItem>>> lessActive = mediaByOwner.entries.where(
      (MapEntry<String, List<MediaItem>> entry) => entry.value.length <= 1,
    );

    for (final MapEntry<String, List<MediaItem>> entry in lessActive) {
      final FamilyMember? member = members.firstWhereOrNull(
        (FamilyMember m) => m.id == entry.key,
      );
      if (member != null) {
        recommendations.add(
          AiRecommendation(
            id: 'encourage-${member.id}',
            title: 'Capture more memories with ${member.displayName}',
            description:
                'It\'s been a while since ${member.displayName} added new photos. Plan an activity and snap a photo together!',
            category: 'engagement',
            metadata: <String, dynamic>{'memberId': member.id},
          ),
        );
      }
    }

    return recommendations;
  }

  Future<AiRecommendation> suggestTaskReward(Task task) async {
    final int points = task.rewardPoints > 0 ? task.rewardPoints : 10;
    return AiRecommendation(
      id: 'task-reward-${task.id}',
      title: 'Reward suggestion',
      description: 'Offer ${points}pts or a family treat when "${task.title}" is completed.',
      category: 'motivation',
      metadata: <String, dynamic>{'taskId': task.id},
    );
  }

  Future<String> generateGiftIdea(FamilyMember member) async {
    final String hobby = member.interests.isNotEmpty ? member.interests.first : 'something meaningful';
    return 'Consider a gift related to $hobby for ${member.displayName}';
  }
}
