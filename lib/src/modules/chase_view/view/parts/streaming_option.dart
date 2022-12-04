import 'package:flutter/material.dart';

import '../../../../shared/platform_views/airplay_view.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';

class StreamingOptionsList extends StatelessWidget {
  const StreamingOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBg(
      color: Colors.grey[100]!.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (Theme.of(context).platform == TargetPlatform.iOS ||
              Theme.of(context).platform == TargetPlatform.macOS)
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[300]!,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                height: 44,
                width: 44,
                child: AirplayView(),
              ),
            ),
        ],
      ),
    );
  }
}