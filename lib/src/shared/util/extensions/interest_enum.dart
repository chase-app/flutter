import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification/notification.dart';

Interests getInterestEnumFromString(String interest) {
  switch (interest) {
    case "chases-notifications":
      return Interests.chases;
    case "AppUpdates":
      return Interests.appUpdates;
    default:
      return Interests.other;
  }
}

enum Interests {
  chases,
  appUpdates,
  other,
}

extension InterestEnum on Interest {
  Interests get getInterestEnum {
    switch (this.name) {
      case "chases-notifications":
        return Interests.chases;
      case "AppUpdates":
        return Interests.appUpdates;
      default:
        return Interests.other;
    }
  }
}

extension NotificationInterestEnum on ChaseAppNotification {
  Interests get getInterestEnumFromName {
    switch (this.interest) {
      case "chases-notifications":
        return Interests.chases;
      case "AppUpdates":
        return Interests.appUpdates;
      default:
        return Interests.other;
    }
  }
}
