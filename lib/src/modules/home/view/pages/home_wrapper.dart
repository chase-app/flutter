import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pusher_beams/pusher_beams.dart';

import '../../../../models/notification/notification.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/notifications/notification_handler.dart';
import '../../../../shared/notifications/notification_pop_up_banner.dart';
import '../parts/helpers.dart';
import 'home_page.dart';

class HomeWrapper extends ConsumerStatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends ConsumerState<HomeWrapper>
    with WidgetsBindingObserver {
  final Logger logger = Logger('HomeWrapper');
  Timer? _timerLink;

  Future<void> navigateToView(Uri deepLink) async {
    final String? chaseId = deepLink.queryParameters['chaseId'];

    await Navigator.pushNamed(
      context,
      RouteName.CHASE_VIEW,
      arguments: {
        'chaseId': chaseId,
      },
    );
  }

  void handleDynamicLinkFromTerminatedState() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink?.path != '/__/auth/action') {
      if (deepLink != null) {
        await navigateToView(deepLink);
      }
    }
  }

  void handlenotifications(RemoteMessage message) async {
    log('ChaseAppNotification Message Arrived--->${message.data}');

    final Map<String, dynamic> data = message.data;
    //TODO: Update with new notification schema

    if (data['Interest'] != null && data['Type'] != null) {
      updateNotificationsPresentStatus(ref, true);
      final ChaseAppNotification notificationData =
          getNotificationDataFromMessage(message);

      await notificationHandler(context, notificationData, read: ref.read);
    } else {
      logger.warning(
        "ChaseAppNotification data didn't contained Interest or Type field--> $data",
      );
    }
  }

  Future<void> handleMessagesFromTerminatedState() async {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      handlenotifications(message);
    }
  }

  Future<void> handlemessagesthatopenedtheappFromBackgroundState() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if (event.data.isNotEmpty) {
        handlenotifications(event);
      }
    });
  }

  void handleDynamicLinkOpenedFromBackgroundState() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        log('Dynamic Link Recieved--->${dynamicLink.link}');
        final Uri deepLink = dynamicLink.link;

        if (deepLink.path != '/__/auth/action') {
          if (deepLink != null) {
            await navigateToView(deepLink);
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        log('Error while recieving dynamic link', error: error);
      },
    );
  }

  void handleNotificationInForegroundState() {
    PusherBeams.instance
        .onMessageReceivedInTheForeground((Map<Object?, Object?> message) {
      log('Pusher Message Recieved in the foreground--->$message');
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(message['data'] as Map<dynamic, dynamic>);
      //TODO: Update with new notification schema
      if (data['Interest'] != null && data['Type'] != null) {
        final ChaseAppNotification notification = constructNotification(
          math.Random().nextInt(10000).toString(),
          message['title'] as String? ?? 'NA',
          message['body'] as String? ?? 'NA',
          data,
        );
        // final notificationData = ChaseAppNotification(
        //   interest: data["Interest"] as String,
        //   title: notification["Title"] as String,
        //   body: notification["Body"] as String,
        //   data: NotificationData.fromJson(data),
        //   image: data["Image"] as String?,
        //   createdAt: data["CreatedAt"] as DateTime,
        // );
        updateNotificationsPresentStatus(ref, true);

        showNotificationBanner(context, notification);
      } else {
        logger.warning(
          "ChaseAppNotification data didn't contained Interest or Type field--> $data",
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    //Dynamic Links Handling
    //Background
    handleDynamicLinkOpenedFromBackgroundState();
    //Terminated
    handleDynamicLinkFromTerminatedState();

    //Notifications Handling
    //Called in Background or Terminated State
    FirebaseMessaging.onBackgroundMessage(handlebgmessage);
    //Foreground
    handleNotificationInForegroundState();
    //Terminated
    handleMessagesFromTerminatedState();
    //Background
    handlemessagesthatopenedtheappFromBackgroundState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        _timerLink = Timer(
          const Duration(milliseconds: 1000),
          () {},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}
