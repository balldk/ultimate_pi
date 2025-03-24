import 'dart:math';

import 'package:flutter/material.dart';

class StatusContainer extends StatefulWidget {
  final String statusType;
  final String statusData;
  final bool large;
  final int rawData;

  const StatusContainer({
    super.key,
    required this.statusType,
    required this.statusData,
    this.large = false,
    this.rawData = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return _StatusContainer();
  }
}

class _StatusContainer extends State<StatusContainer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  double fontSize = 14.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
              child: Text(
                widget.statusType,
                style: TextStyle(
                  color: widget.large ? Colors.white70 : Colors.grey,
                  fontSize: widget.large ? 16.0 : 12.0,
                ),
              ),
            ),
            Text(widget.statusData, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class Streak extends StatelessWidget {
  final int streak;
  final List<String> lostStreakEmoji = [
    '🤬',
    '😡',
    '😢',
    '😩',
    '👎',
    '🔫',
    '💔',
    '⛔️',
  ];

  final List<String> streakEmoji = [
    '',
    '',
    '',
    '🤩',
    '😍',
    '😎',
    '🙏',
    '🍆',
    '🙀',
    '😀',
    '❗️',
    '🥑',
    '😱',
    '🤯',
    '🌶',
    '🤤',
    '🤗',
    '💓',
    '🤠',
    '🙋‍',
    '👀',
    '💃',
    '☝️',
    '💪🏽',
    '🔥',
    '🌞',
    '🇸🇪',
    '🍿',

    '👌',
    '🤓',
    '👊',
    '⭐️',
    '🍌',
    '❤️',
  ];

  Streak({super.key, required this.streak});

  String getStreakEmoji(Random random) {
    if (streak > streakEmoji.length - 1) {
      return streakEmoji[random.nextInt(streakEmoji.length)];
    }

    return streakEmoji[streak];
  }

  List<TextSpan> getRandomStreak() {
    final random = Random();
    List<TextSpan> list = [];
    int count = streak <= 8 ? streak : 8;
    for (var i = 0; i < count; i++) {
      list.add(TextSpan(text: getStreakEmoji(random)));
    }
    list.insert(
      (list.length / 2).round(),
      TextSpan(
        text: streak.toString(),
        style: TextStyle(
          fontSize: 26.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          decorationStyle: TextDecorationStyle.solid,
          decorationColor: Colors.blue,
          decoration: TextDecoration.underline,
          letterSpacing: 1.0,
        ),
      ),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 16.0,
          fontSize: 16.0,
        ),
        children: getRandomStreak(),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  final int digits;
  final int errors;
  final int streak;
  final int points;

  const StatusBar({
    super.key,
    required this.digits,
    required this.errors,
    required this.streak,
    required this.points,
  });

  String getSuccessRate() {
    double successRate = (100 - ((errors / digits) * 100));
    if (successRate.isNaN) {
      return '100%';
    }
    String successRateString = successRate.round().toString();
    return '$successRateString%';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child:
          streak > 2
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[Streak(streak: streak)],
              )
              : Row(
                children: <Widget>[
                  StatusContainer(
                    statusType: 'decimals',
                    statusData: digits.toString(),
                  ),
                  StatusContainer(
                    statusType: 'points',
                    statusData: points.toString(),
                    rawData: points,
                    large: true,
                  ),
                  StatusContainer(
                    statusType: 'success rate',
                    statusData: getSuccessRate(),
                  ),
                ],
              ),
    );
  }
}
