import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final chatChannelProvider = Provider.family<Channel, Chase>((ref, chase) {
  final channel = client.channel(
    'livestream',
    id: chase.id,
    extraData: {
      'name': chase.name ?? "NA",
    },
  );

  return channel;
});
