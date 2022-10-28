import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../providers/providers.dart';
import 'chase_details.dart';
import 'video_animations_overlay.dart';
import 'video_top_actions.dart';

class ChaseDetailsInternal extends ConsumerStatefulWidget {
  const ChaseDetailsInternal({
    Key? key,
    required this.chase,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
    required this.logger,
    required this.chatsRow,
    required this.chatsView,
  }) : super(key: key);
  final Chase chase;
  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;
  final Logger logger;
  final Widget chatsRow;
  final Widget chatsView;

  @override
  ConsumerState<ChaseDetailsInternal> createState() =>
      _ChaseDetailsInternalState();
}

class _ChaseDetailsInternalState extends ConsumerState<ChaseDetailsInternal> {
  final bool expandChats = false;
  late YoutubePlayerController _controller;

  late final Animation<Offset> appBarOffsetAnimation;
  late final Animation<Offset> bottomListAnimation;
  late final Chase chase;
  void initializeVideoController(String? videoId) {
    late final String? url;
    late final String? playerVideoId;
    if (videoId == null) {
      final ChaseNetwork? network =
          widget.chase.networks?.firstWhereOrNull((ChaseNetwork network) {
        final String? url = network.url;

        if (url != null) {
          return isValidYoutubeUrl(url);
        }

        return false;
      });
      url = network?.url;
      playerVideoId = url != null ? parseYoutubeUrlForVideoId(url) : null;
      Future<void>.microtask(() {
        ref
            .read(playingVideoIdProvider.state)
            .update((String? state) => playerVideoId);
      });
    } else {
      playerVideoId = videoId;
    }

    _controller = YoutubePlayerController(
      initialVideoId: playerVideoId ?? '',
      flags: YoutubePlayerFlags(
        isLive: widget.chase.live ?? false,
        autoPlay: false,
      ),
    );

    setState(() {});
  }

  Future<void> changeYoutubeVideo(String url) async {
    final String? videoId = parseYoutubeUrlForVideoId(url);
    await Future<void>.microtask(() {
      ref.read(playingVideoIdProvider.state).update((String? state) => videoId);
    });

    initializeVideoController(
      videoId,
    );
    ref.read(playVideoProvider.state).update((bool state) => false);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    ref.read(playVideoProvider.state).update((bool state) => true);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController(null);
    appBarOffsetAnimation = widget.appBarOffsetAnimation;
    bottomListAnimation = widget.bottomListAnimation;
    chase = widget.chase;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (ref.read(isShowingChatsWindowProvide)) {
            ref
                .read(isShowingChatsWindowProvide.state)
                .update((bool state) => false);
            return false;
          }
          return true;
        },
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            topActions: const VideoTopActions(),
            overlayInBetween: VideoAnimationsOverlay(
              controller: _controller,
              chase: chase,
            ),
          ),
          builder: (BuildContext context, Widget video) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: AnimatedBuilder(
                animation: bottomListAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: bottomListAnimation.value,
                    child: child,
                  );
                },
                child: ChaseDetails(
                  chase: chase,
                  imageURL: chase.imageURL,
                  logger: widget.logger,
                  youtubeVideo: video,
                  onYoutubeNetworkTap: changeYoutubeVideo,
                  chatsRow: widget.chatsRow,
                  chatsView: widget.chatsView,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
