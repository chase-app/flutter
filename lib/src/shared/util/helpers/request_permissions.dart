import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkForPermissionsStatuses() async {
  final bluetoothStatus = await Permission.bluetooth.isGranted;
  final bluetoothScanStatus =
      Platform.isAndroid ? await Permission.bluetoothScan.isGranted : true;
  final bluetoothConnectStatus =
      Platform.isAndroid ? await Permission.bluetoothConnect.isGranted : true;
  final locationStatus = await Permission.locationWhenInUse.isGranted;
  final notificationStatus = await Permission.notification.isGranted;

  return bluetoothStatus &&
      bluetoothScanStatus &&
      bluetoothConnectStatus &&
      locationStatus &&
      notificationStatus;
}

Future<UsersPermissionStatuses> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    if (Platform.isAndroid) ...[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ],
    Permission.locationWhenInUse,
    Permission.notification,
  ].request();

  List<Permission> permanentlyDeniedPermissions = [];

  for (var entry in statuses.entries) {
    final status = entry.value;
    if (status == PermissionStatus.granted) {
      if (kDebugMode) {
        log('BTServiceStatus - Permission Granted');
      }
    } else if (status == PermissionStatus.denied) {
      if (kDebugMode) {
        log('BTServiceStatus - Permission Denied');
      }

      return UsersPermissionStatuses(
        UsersPermissionStatus.DENIED,
        permanentlyDeniedPermissions,
      );
    } else if (status == PermissionStatus.permanentlyDenied) {
      permanentlyDeniedPermissions.add(entry.key);
      if (kDebugMode) {
        log('BTServiceStatus - Permission Permanently Denied');
      }
    }
  }

  return UsersPermissionStatuses(
    permanentlyDeniedPermissions.isNotEmpty
        ? UsersPermissionStatus.PERMANENTLY_DENIED
        : UsersPermissionStatus.ALLOWED,
    permanentlyDeniedPermissions,
  );
}

class UsersPermissionStatuses {
  UsersPermissionStatuses(
    this.status,
    this.permanentlyDeniedPermissions,
  );
  final UsersPermissionStatus status;
  final List<Permission> permanentlyDeniedPermissions;
}

enum UsersPermissionStatus {
  ALLOWED,
  DENIED,
  PERMANENTLY_DENIED,
}
