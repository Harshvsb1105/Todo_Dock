import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/todo_models.dart';
import '../style.dart';
import 'animated_percent.dart';

class HeroProgress extends StatelessWidget {
  const HeroProgress({
    Key key,
    @required this.category,
  }) : super(key: key);

  final TodoCategory category;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'progress_${category.id}',
      flightShuttleBuilder: flightShuttleBuilderFix,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'task_card',
            style: TextStyle(
                color:
                    NeumorphicTheme.defaultTextColor(context).withOpacity(0.5),
                fontSize: 16.00),
          ).plural(category.totalItems),
          const SizedBox(
            height: Style.halfPadding,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NeumorphicProgress(
                    percent: category.percent,
                    height: 8,
                    duration: const Duration(milliseconds: 300),
                    style: ProgressStyle(
                        depth: NeumorphicTheme.depth(
                            context) // TODO: fix depth and others
                        )),
              ),
              SizedBox(
                width: Style.mainPadding,
              ),
              Container(
                width: 48,
                alignment: Alignment.centerRight,
                child: AnimatedPercent(
                  category.percent,
                  style: TextStyle(
                      color: NeumorphicTheme.defaultTextColor(context)
                          .withOpacity(0.5),
                      fontSize: 16.00),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class HeroTitle extends StatelessWidget {
  const HeroTitle({
    Key key,
    @required this.category,
  }) : super(key: key);

  final TodoCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
          tag: 'title_${category.id}',
          flightShuttleBuilder: flightShuttleBuilderFix,
          child: Text(
            category.title,
            style: TextStyle(
                color: NeumorphicTheme.defaultTextColor(context), fontSize: 40.00),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
      ),
    );
  }
}

class HeroIcon extends StatelessWidget {
  const HeroIcon({
    Key key,
    @required this.category,
  }) : super(key: key);

  final TodoCategory category;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'icon_${category.id}',
      child: Neumorphic(
        padding: const EdgeInsets.all(16),
        style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            shape: NeumorphicShape.convex),
        child: FaIcon(
          category.icon,
          color: Style.primaryColor,
          size: 32,
        ),
      ),
    );
  }
}

Widget flightShuttleBuilderFix(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  ///fix overflow flex
  return SingleChildScrollView(
    //fix missed style
    child: DefaultTextStyle(
        style: DefaultTextStyle.of(fromHeroContext).style,
        child: fromHeroContext.widget),
  );
}

class HeroCircularProgress extends StatelessWidget {
  const HeroCircularProgress({
    Key key,
    @required this.category,
  }) : super(key: key);

  final TodoCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Hero(
        tag: 'progress_${category.id}',
        flightShuttleBuilder: flightShuttleBuilderFix,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Your Progress',style: TextStyle(
              color: NeumorphicTheme.defaultTextColor(context).withOpacity(0.5),fontSize: 16.00
            ),),
             Center(
                child: CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width * 0.5,
                  lineWidth: 15.0,
                  percent: category.percent,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: AnimatedPercent(
                category.percent,
                style: TextStyle(
                    color: NeumorphicTheme.defaultTextColor(context)
                        .withOpacity(0.5),
                    fontSize: 32.00),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
              ),
              progressColor: Color(0xffea4c86),
            ),),
          ],
        ),
      ),
    );
  }
}

class HeroIconRectangular extends StatelessWidget {
  const HeroIconRectangular({
    Key key,
    @required this.category,
  }) : super(key: key);

  final TodoCategory category;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'icon_${category.id}',
      child: Neumorphic(
        padding: const EdgeInsets.all(8),
        style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
                (BorderRadius.all(Radius.circular(30)))),
            shape: NeumorphicShape.convex),
        child: Center(
          widthFactor: 4,
          child: FaIcon(
            category.icon,
            color: Style.primaryColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}
