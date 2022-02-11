import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:chaseapp/src/shared/widgets/chase/donut_box.dart';
import 'package:chaseapp/src/shared/widgets/sentiment_analysis_slider.dart';
import 'package:flutter/material.dart';

class TopChaseBuilder extends StatelessWidget {
  const TopChaseBuilder({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    final isImagePresent = chase.imageURL != null && chase.imageURL!.isNotEmpty;
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          kBorderRadiusStandard,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  kBorderRadiusStandard,
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    primaryColor.shade800,
                    Colors.transparent,
                  ],
                )),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: isImagePresent
                    ? CachedNetworkImageProvider(
                        chase.imageURL!,
                      )
                    : AssetImage(
                        defaultChaseImage,
                      ) as ImageProvider,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await Future<void>.delayed(Duration(milliseconds: 300));
                Navigator.pushNamed(context, RouteName.CHASE_VIEW, arguments: {
                  "chaseId": chase.id,
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(
                  kPaddingSmallConstant,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassButton(
                      child: Text(
                        dateAdded(chase),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chase.name ?? "NA",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Theme.of(context).textTheme.subtitle1!.fontSize,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SentimentSlider(),
                            ),
                            SizedBox(
                              width: kItemsSpacingMediumConstant,
                            ),
                            DonutBox(chase: chase),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}