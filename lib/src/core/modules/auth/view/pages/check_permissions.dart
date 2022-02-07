import 'dart:developer';

import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/info.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permanently_denied_dialog.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permissions_row.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';

class CheckPermissionsView extends StatelessWidget {
  const CheckPermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.all(kPaddingMediumConstant).copyWith(bottom: 0),
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            Image.asset(
              chaseAppNameImage,
              height: kImageSizeLarge,
            ),
            SizedBox(
              height: kItemsSpacingMediumConstant,
            ),
            Container(
              padding: EdgeInsets.all(
                kListPaddingConstant,
              ),
              decoration: BoxDecoration(
                color: primaryColor.shade500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  Expanded(
                    child: Text(
                      '''ChaseApp requires the following permissions to proceed.\n''',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kItemsSpacingLarge,
            ),
            PermissionRow(
              icon: Icons.location_pin,
              title: "Location",
              subTitle: "Location permissions for location tracking.",
              info: locationUsageInfo,
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            PermissionRow(
              icon: Icons.bluetooth_connected,
              title: "Bluetooth",
              subTitle: "Bluetooth permissions for bluetooth activities.",
              info: bluetoothUsageInfo,
            ),
            Divider(),
            PermissionRow(
              icon: Icons.notifications_active,
              title: "Notifications",
              subTitle: "Notifications permission for recieving notifications.",
              info: notificationsUsageInfo,
            ),
            Divider(),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
            GrantAllPermissionsButton(),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class GrantAllPermissionsButton extends StatefulWidget {
  const GrantAllPermissionsButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GrantAllPermissionsButton> createState() =>
      _GrantAllPermissionsButtonState();
}

class _GrantAllPermissionsButtonState extends State<GrantAllPermissionsButton> {
  late bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: isLoading
          ? CircularAdaptiveProgressIndicator()
          : ElevatedButton(
              style: callToActionButtonStyle,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final UsersPermissionStatuses usersPermissions =
                    await requestPermissions();

                setState(() {
                  isLoading = false;
                });

                if (usersPermissions.status == UsersPermissionStatus.DENIED) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please Grant All Permissions To Proceed."),
                  ));
                } else if (usersPermissions.status ==
                    UsersPermissionStatus.PERMANENTLY_DENIED) {
                  await showPermanentlyDeniedDialog(
                    context,
                    usersPermissions.permanentlyDeniedPermissions,
                  );
                } else {
                  //All permissions granted
                  log("All Permissions Granted");

                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.AUTH_VIEW_WRAPPER,
                  );
                }
              },
              child: Text(
                "Grant All Permissions",
                style: getButtonStyle(context),
              ),
            ),
    );
  }
}


//flutter: BTServiceStatus - Permission Permanently Denied
// * thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGKILL
//     frame #0: 0x00000001bd4c4b10 libsystem_kernel.dylib`mach_msg_trap + 8
// libsystem_kernel.dylib`mach_msg_trap:
// ->  0x1bd4c4b10 <+8>: ret
// libsystem_kernel.dylib`mach_msg_overwrite_trap:
//     0x1bd4c4b14 <+0>: mov    x16, #-0x20
//     0x1bd4c4b18 <+4>: svc    #0x80
//     0x1bd4c4b1c <+8>: ret
// Target 0: (Runner) stopped.
// Lost connection to device.