import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../numbers.dart';
import './input-pad.dart';
import './presenter.dart';
import './status-bar.dart';
import '../../entered.dart';

class Training extends StatefulWidget {
  const Training({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Training();
  }
}

class _Training extends State<Training> {
  /* List<Map> values = []; */
  List<Entered> values = [];
  int points = 0;
  DateTime? latestValueTime;
  String streakId = 'id';
  int errors = 0;
  int streak = 0;
  Timer? timer;
  int topResults = 0;
  int topStreak = 0;
  int topPoints = 0;

  @override
  void initState() {
    super.initState();

    getTopResult();
    getTopStreak();
    getTopPoints();
  }

  bool isCorrect(int position, String value) {
    return piNumbers[position] == value;
  }

  String getCorrectPi(int position) {
    return piNumbers[position];
  }

  String _randomString(int length) {
    var rand = Random();
    var codeUnits = List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return String.fromCharCodes(codeUnits);
  }

  void reCalculateValues() {
    int index = 0;
    values =
        values.map((Entered value) {
          if (value.isAfter(value.timeNow)) {
            var currentId = value.streakId;
            if (index - 1 != -1) {
              var prev = values[index - 1];
              var prevId = prev.streakId;
              var prevCorrect = prev.isCorrect;
              if (prevId == currentId && value.isCorrect && prevCorrect) {
                value.isOnStreak = true;
              }
            }
            if (index + 1 <= values.length - 1) {
              var next = values[index + 1];
              var nextId = next.streakId;
              var nextCorrect = next.isCorrect;
              if (nextId == currentId && value.isCorrect && nextCorrect) {
                value.isOnStreak = true;
              }
            }
          }
          index += 1;
          return value;
        }).toList();
  }

  int getStreakPoint(int streak) {
    int points = 0;
    for (var i = 1; i <= streak; i++) {
      points += i - 1;
    }
    return points;
  }

  List<int> getLongestStreak(List<Entered> values) {
    int index = 0;

    int longestStreakStartPosition = -1;
    int longestStreakEndPosition = -1;
    int longestStreakLength = 0;

    bool isCurrentrlyOnStreak = false;
    int currentStreakStartPosition = -1;
    int currentStreakEndPosition = -1;
    int currentStreakLength = 0;
    for (var current in values) {
      // is not first value
      if (index == 0 && values.length > 1) {
        Entered next = values[index + 1];
        if (current.isSameStreakId(next)) {
          // should always be false bu hwo knows..
          if (!isCurrentrlyOnStreak) {
            isCurrentrlyOnStreak = true;
            currentStreakStartPosition = index;
            currentStreakLength += 1;
          }
        }
      } else if (index != 0) {
        Entered prevoius = values[index - 1];
        if (current.isSameStreakId(prevoius)) {
          // is first value of streak
          if (!isCurrentrlyOnStreak) {
            isCurrentrlyOnStreak = true;
            currentStreakStartPosition = index;
          }

          currentStreakLength += 1;
        } else {
          if (isCurrentrlyOnStreak) {
            isCurrentrlyOnStreak = false;
            currentStreakEndPosition = index;

            if (currentStreakLength > longestStreakLength) {
              longestStreakLength = currentStreakLength;

              longestStreakStartPosition = currentStreakStartPosition;
              longestStreakEndPosition = currentStreakEndPosition;

              currentStreakLength = 0;
              currentStreakStartPosition = -1;
              currentStreakEndPosition = -1;
            }
          }
        }
      }

      // is on streak for last value
      if (index == values.length - 1) {
        if (isCurrentrlyOnStreak) {
          isCurrentrlyOnStreak = false;
          currentStreakEndPosition = index;

          if (currentStreakLength > longestStreakLength) {
            longestStreakLength = currentStreakLength;

            longestStreakStartPosition = currentStreakStartPosition;
            longestStreakEndPosition = currentStreakEndPosition;

            currentStreakLength = 0;
            currentStreakStartPosition = -1;
            currentStreakEndPosition = -1;
          }
        }
      }

      index += 1;
    }

    if (longestStreakStartPosition != 0) {
      longestStreakLength += 1;
      longestStreakStartPosition -= 1;
      longestStreakEndPosition -= 1;
    }

    return [
      longestStreakLength,
      longestStreakStartPosition,
      longestStreakEndPosition,
    ];
  }

  int getResult(List<Entered> values) {
    int index = 0;
    for (final value in this.values) {
      if (!value.isCorrect) {
        break;
      }
      index += 1;
    }

    return index;
  }

  void saveRecordLength(int newResult, {bool state = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int topResult = (prefs.getInt('topResult') ?? 0);

    if (newResult > topResult) {
      await prefs.setInt('topResult', newResult);
      if (state) {
        setState(() {
          topResults = newResult;
        });
      }
    }
  }

  void saveTopStreak(
    int newStreak,
    int start,
    int end, {
    bool state = true,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int topStreak = (prefs.getInt('topStreak') ?? 0);

    if (newStreak > topStreak) {
      await prefs.setInt('topStreak', newStreak);
      await prefs.setInt('streakStart', start);
      await prefs.setInt('streakEnd', end);
      if (state) {
        setState(() {
          this.topStreak = newStreak;
        });
      }
    }
  }

  void saveTopPoints(int points, {bool state = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int topPoints = (prefs.getInt('topPoints') ?? 0);

    if (points > topPoints) {
      await prefs.setInt('topPoints', points);
      if (state) {
        setState(() {
          this.topPoints = points;
        });
      }
    }
  }

  void getTopResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topResult') ?? 0);
    setState(() {
      topStreak = value;
    });
  }

  void getTopStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topStreak') ?? 0);
    setState(() {
      topStreak = value;
    });
  }

  void getTopPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topPoints') ?? 0);
    setState(() {
      topPoints = value;
    });
  }

  @override
  void dispose() {
    super.dispose();

    var streakData = getLongestStreak(values);
    int streakLength = streakData[0];
    int streakStartPosition = streakData[1];
    int streakEndPosition = streakData[2];
    int result = getResult(values);

    if (streakLength > topStreak) {
      saveTopStreak(
        streakLength,
        streakStartPosition,
        streakEndPosition,
        state: false,
      );
    }
    if (result > topResults) {
      saveRecordLength(result, state: false);
    }

    if (points > topPoints) {
      saveTopPoints(points, state: false);
    }
  }

  void onPress(String value) {
    if (value == 'CLEAR') {
      setState(() {
        if (values.length > 1) {
          var streakData = getLongestStreak(values);
          int streakLength = streakData[0];
          int streakStartPosition = streakData[1];
          int streakEndPosition = streakData[2];
          int result = getResult(values);

          if (streakLength > topStreak) {
            saveTopStreak(streakLength, streakStartPosition, streakEndPosition);
          }
          if (result > topResults) {
            saveRecordLength(result);
          }

          if (points > topPoints) {
            saveTopPoints(points);
          }
        }

        points = 0;
        errors = 0;
        values.clear();
        streak = 0;
        streakId = _randomString(10);
        latestValueTime = null;
        if (timer != null) {
          timer?.cancel();
        }
      });
    } else {
      setState(() {
        var isCorrect = this.isCorrect(values.length, value);
        if (!isCorrect) {
          errors = errors + 1;
          streakId = _randomString(10);
          latestValueTime = null;
          reCalculateValues();
          if (timer != null) {
            if (streak > 1) {
              points += getStreakPoint(streak);
            }
            timer?.cancel();
          }
          streak = 0;
        } else {
          points += 1;
        }

        var timeNow = DateTime.now();
        var time = latestValueTime ?? DateTime.now();
        var plusFive = time.add(Duration(milliseconds: 400));
        if (isCorrect) {
          if (plusFive.isBefore(timeNow)) {
            if (timer != null) {
              timer?.cancel();
            }
            latestValueTime = DateTime.now();
            plusFive = DateTime.now();
            streakId = _randomString(10);
            if (streak > 1) {
              points += getStreakPoint(streak);
            }
            streak = 1;
            reCalculateValues();
          } else {
            streak = streak + 1;

            if (timer != null) {
              timer?.cancel();
            }
            timer = Timer(Duration(seconds: 1), () {
              setState(() {
                if (streak > 1) {
                  points += getStreakPoint(streak);
                }
                streak = 0;
                streakId = _randomString(10);
                reCalculateValues();
                latestValueTime = null;
              });
            });
          }
        }

        Entered entered = Entered(
          value: value,
          inputTime: plusFive,
          timeNow: timeNow,
          isCorrect: isCorrect,
          streakId: streakId,
          position: values.length,
          correctValue: getCorrectPi(values.length),
        );

        values.add(entered);
        latestValueTime = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Presenter(streak: streak, values: values, errors: errors),
            ),
            StatusBar(
              errors: errors,
              points: points,
              digits: values.length,
              streak: streak,
            ),
            Expanded(
              flex: 0,
              child: Pad(onPress: onPress, disableClear: streak > 2),
            ),
          ],
        ),
      ),
    );
  }
}
