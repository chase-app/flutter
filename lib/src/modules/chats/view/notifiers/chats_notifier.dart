import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../../flavors.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/notification/notification_data/notification_data.dart';
import '../../../../models/user/user_data.dart';
import '../../../../shared/enums/firehose_notification_type.dart';
import '../../../../shared/enums/interest_enum.dart';
import '../../../../shared/util/convertors/datetimeconvertor.dart';
import '../../../../shared/util/extensions/interest_enum.dart';
import '../providers/providers.dart';

class ChatStateNotifier extends StateNotifier<void> {
  ChatStateNotifier(this.read) : super(null);

  final Reader read;

  final Logger logger = Logger('ChatsServiceStateNotifier');

  late final String userToken;

  bool isSubscribedToFeed = false;

  final stream.StreamChatClient _client = stream.StreamChatClient(
    _getChatApiKey,
    logLevel: Level.INFO,
  );
  final feed.StreamFeedClient _streamFeedClient =
      feed.StreamFeedClient(_getChatApiKey, appId: '102359');

  static String get _getChatApiKey {
    if (F.appFlavor == Flavor.DEV) {
      const String apiKey =
          String.fromEnvironment('Dev_GetStream_Chat_Api_Key');

      return apiKey;
    } else {
      const String apiKey =
          String.fromEnvironment('Prod_GetStream_Chat_Api_Key');

      return apiKey;
    }
  }

  feed.FlatFeed get firehoseFeed =>
      _streamFeedClient.flatFeed('events', 'firehose');

  stream.StreamChatClient get client => _client;
  feed.StreamFeedClient get streamFeed => _streamFeedClient;

  Future<void> setUserAndSubscribe() async {
    if (_streamFeedClient.currentUser == null) {
      final UserData userData = await read(userStreamProvider.future);
      final String userToken =
          await read(chatsRepoProvider).getUserToken(userData.uid);
      await _streamFeedClient.setUser(
        feed.User(
          id: userData.uid,
        ),
        feed.Token(userToken),
      );
    }
    await subscribeToFeed();
  }

  Future<List<ChaseAppNotification>> fetchFirehoseFeed(int offset) async {
    await setUserAndSubscribe();

    final List<feed.Activity> activities =
        await firehoseFeed.getActivities(limit: 20, offset: offset);

    return activities.map(convertActivityToChaseAppNotification).toList();
  }

  Future<void> connectUserToGetStream(UserData userData) async {
    try {
      userToken = await read(chatsRepoProvider).getUserToken(userData.uid);

      if (client.wsConnectionStatus == stream.ConnectionStatus.disconnected) {
        await client.connectUser(
          stream.User(
            id: userData.uid,
            name: userData.userName?.split(' ')[0] ?? 'Unknown',
            image: userData.photoURL,
          ),
          userToken,
        );
      }
    } catch (e, stk) {
      logger.severe('Error while connecting user to getStream', e, stk);
    }
  }

  Future<void> subscribeToFeed() async {
    if (!isSubscribedToFeed) {
      await firehoseFeed.subscribe(
        (feed.RealtimeMessage<Object?, Object?, Object?, Object?>? message) {},
      );
      isSubscribedToFeed = true;
    }
  }

  Future<void> disconnectUser() async {
    try {
      await client.disconnectUser();
    } catch (e, stk) {
      logger.severe('Error while disconnecting user from getStream', e, stk);
    }
  }
}

// ignore: long-method
ChaseAppNotification convertActivityToChaseAppNotification(
  feed.Activity activity,
) {
  final String type = activity.extraData!['eventType']! as String;
  final Map<String, dynamic> payload =
      activity.extraData!['payload']! as Map<String, dynamic>;
  final String? title = payload['title'] as String?;
  final String? body = payload['body'] as String?;
  final String? image = payload['image_url'] as String?;
  final DateTime createdAt =
      parseDate(activity.extraData!['created_at']! as int);
  final String? id = payload['id'] as String?;
  late final NotificationData data;
  switch (getFirehoseNotificationTypeFromString(type)) {
    case FirehoseNotificationType.twitter:
      data = NotificationData(
        tweetId: id,
        image: image,
      );
      break;

    case FirehoseNotificationType.streams:
      data = NotificationData(
        youtubeId: id,
        image: image,
      );
      break;

    case FirehoseNotificationType.chase:
      data = NotificationData(
        id: id,
        image: image,
      );
      break;

    case FirehoseNotificationType.live_on_patrol:
      data = NotificationData(
        id: id,
        image: image,
      );
      break;

    case FirehoseNotificationType.events:
      data = NotificationData(
        // id: id,
        image: image,
      );
      break;

    default:
      data = NotificationData(
        // id: id,
        image: image,
      );
      break;
  }

  return ChaseAppNotification(
    interest: getStringFromInterestEnum(Interests.firehose)!,
    type: type,
    title: title ?? 'NA',
    body: body ?? 'NA',
    id: activity.id!,
    createdAt: createdAt,
    data: data,
  );
}
