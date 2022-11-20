import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/sizings.dart';
import 'animations_overlay_toggle_switch.dart';

class VideoTopActions extends StatelessWidget {
  const VideoTopActions({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: kPaddingSmallConstant,
          right: kPaddingSmallConstant,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.landscape) {
                  controller.toggleFullScreenMode();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const AnimationsOverlayToggleSwitch(),
            const SizedBox(
              width: kItemsSpacingSmallConstant,
            ),
          ],
        ),
      ),
    );
  }
}
