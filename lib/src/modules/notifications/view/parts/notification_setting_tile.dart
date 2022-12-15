// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/notifiers/in_app_purchases_state_notifier.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/interest/interest.dart';
import '../../../in_app_purchases/views/view_helpers.dart';
import '../providers/providers.dart';

class NotificationSettingTile extends StatelessWidget {
  const NotificationSettingTile({
    Key? key,
    required this.interest,
    required this.isUsersInterest,
  }) : super(key: key);

  final Interest interest;
  final bool isUsersInterest;

  @override
  Widget build(BuildContext context) {
    final String displayName =
        toBeginningOfSentenceCase(interest.name.split('-')[0])!;

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        displayName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: NotificationSettingTileSwitch(
        interest: interest,
        isUsersInterest: isUsersInterest,
        displayName: displayName,
      ),
    );
  }
}

class NotificationSettingTileSwitch extends ConsumerStatefulWidget {
  const NotificationSettingTileSwitch({
    Key? key,
    required this.interest,
    required this.isUsersInterest,
    required this.displayName,
  }) : super(key: key);

  final Interest interest;
  final bool isUsersInterest;
  final String displayName;

  @override
  ConsumerState<NotificationSettingTileSwitch> createState() =>
      _NotificationSettingTileSwitchState();
}

class _NotificationSettingTileSwitchState
    extends ConsumerState<NotificationSettingTileSwitch> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.interest.isCompulsory || widget.isUsersInterest;
  }

  // ignore: long-method
  Future<void> toggleSubscription(bool value) async {
    final bool isPremiumMember = ref
            .read(inAppPurchasesStateNotifier.notifier)
            .state
            .value
            ?.isPremiumMember ??
        false;

    if (!isPremiumMember) {
      await showInAppPurchasesBottomSheet(context);

      return;
    }

    try {
      if (value) {
        await ref
            .read(pusherBeamsProvider)
            .addDeviceInterest(widget.interest.name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Subscribed to ${widget.displayName} notifications.',
            ),
          ),
        );
      } else {
        await ref
            .read(pusherBeamsProvider)
            .removeDeviceInterest(widget.interest.name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'UnSubscribed from ${widget.displayName} notifications.',
            ),
          ),
        );
      }
      setState(() {
        isEnabled = value;
        ref.refresh(usersInterestsStreamProvider);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again later.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isEnabled,
      onChanged: widget.interest.isCompulsory ? null : toggleSubscription,
    );
  }
}
