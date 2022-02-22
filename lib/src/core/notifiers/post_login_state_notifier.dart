import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pusher_beams/pusher_beams.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Logger logger = Logger("PostLoginStateNotifier");

  Future<void> initPostLoginActions(User user, UserData userData) async {
    if (!isInitialized) {
      await _initFirebaseActions(user, userData);
      await PusherBeams.instance.addDeviceInterest("chases-notifications");
      isInitialized = true;
    }
  }

  Future<void> _initFirebaseActions(User user, UserData userData) async {
    final lastTokenUpdate = userData.lastTokenUpdate;
    final tokens = userData.tokens;
    String? token = await _read(firebaseMesssagingProvider).getToken();

    if (token != null) {
      try {
        if (lastTokenUpdate != null && tokens != null) {
          final today = DateTime.now();
          final difference = today.difference(lastTokenUpdate).inDays;
          final isTokenPresent =
              tokens.any((oldToken) => oldToken.token == token);

          if (difference > 7 || !isTokenPresent) {
            //update tokens
            _read(authRepoProvider).saveDeviceTokenToDatabase(user, token);
          }
          if (difference > 28 || !isTokenPresent) {
            _read(authRepoProvider).subscribeToTopics();
          }
        } else {
          _read(authRepoProvider).saveDeviceTokenToDatabase(user, token);
          _read(authRepoProvider).subscribeToTopics();
        }

        _read(firebaseCrashlyticsProvider).setUserIdentifier(userData.uid);
        _read(authRepoProvider).updateTokenWhenRefreshed(user);
      } catch (e, stk) {
        logger.warning("Error in initPostLogin Firebase Actions", e, stk);
      }
    }
  }
}
