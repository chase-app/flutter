import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db_ab.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';

class NotificationsDatabase implements NotificationsDbAB {
  NotificationsDatabase();

  Future<List<NotificationData>> fetchNotifications(
      NotificationData? notificationData,
      String? notificationType,
      String userId) async {
    if (notificationData == null) {
      final documentSnapshot = await notificationsCollectionRef(userId)
          .where("id", isEqualTo: notificationType)
          .orderBy("CreatedAt", descending: true)
          .limit(20)
          .get();
      return documentSnapshot.docs
          .map<NotificationData>(
            (snapshot) => snapshot.data(),
          )
          .toList();
    } else {
      final documentSnapshot = await notificationsCollectionRef(userId)
          .where("id", isEqualTo: notificationType)
          .orderBy("CreatedAt", descending: true)
          .startAfter([notificationData.createdAt])
          .limit(20)
          .get();
      return documentSnapshot.docs
          .map<NotificationData>(
            (snapshot) => snapshot.data(),
          )
          .toList();
    }
  }
}
