import 'package:flutter/material.dart';

import '../models/media_item.dart';

class MediaTile extends StatelessWidget {
  const MediaTile({
    super.key,
    required this.mediaItem,
  });

  final MediaItem mediaItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 3 / 2,
            child: mediaItem.url.startsWith('http')
                ? Image.network(mediaItem.url, fit: BoxFit.cover)
                : Image.asset(mediaItem.url, fit: BoxFit.cover),
          ),
          if (mediaItem.caption != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(mediaItem.caption!, style: Theme.of(context).textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }
}
