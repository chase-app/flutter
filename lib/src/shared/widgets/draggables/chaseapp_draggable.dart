import 'package:flutter/material.dart';

import '../../../const/sizings.dart';

class ChaseAppDraggableContainer extends StatefulWidget {
  const ChaseAppDraggableContainer({
    super.key,
    required this.child,
    required this.onExpandTap,
  });

  final Widget child;
  final Function() onExpandTap;

  @override
  State<ChaseAppDraggableContainer> createState() =>
      _ChaseAppDraggableContainerState();
}

class _ChaseAppDraggableContainerState
    extends State<ChaseAppDraggableContainer> {
  Offset topLeft = const Offset(0, 0);
  bool isMoved = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isMoved) {
      final double calculatedWidth =
          MediaQuery.of(context).size.width * (1 - 0.5);
      topLeft = const Offset(
        0,
        // calculatedWidth > 350
        //     ? MediaQuery.of(context).size.width - 350
        //     : calculatedWidth,
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topLeft.dy,
      left: topLeft.dx,
      child: Stack(
        // clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            left: -10,
            right: -10,
            top: -10,
            bottom: -10,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                isMoved = true;
                setState(() {
                  topLeft += details.delta;
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius:
                      BorderRadius.circular(kBorderRadiusLargeConstant),
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 350,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(kBorderRadiusLargeConstant),
                    clipBehavior: Clip.hardEdge,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
