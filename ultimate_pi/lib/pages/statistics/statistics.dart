import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stats extends StatelessWidget {
  final int data;
  final String title;

  Stats({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            this.data.toString(),
            style: TextStyle(color: Colors.white, fontSize: 70.0),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(this.title, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class Statistics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Statistics();
  }
}

class _Statistics extends State<Statistics> {
  int points = 0;
  int streak = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    getTotal();
    getStreak();
    getTopPoints();
  }

  void getTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topResult') ?? 0);
    setState(() {
      this.total = value;
    });
  }

  void getStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topStreak') ?? 0);
    setState(() {
      this.streak = value;
    });
  }

  void getTopPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topPoints') ?? 0);
    setState(() {
      this.points = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          int total = this.total;
          int point = points;
          int combo = streak;
          Share.share(
            'I know $total decimals of π!! and i got a score of $point with my longest combo $combo, crush my score here: https://goo.gl/J6YaVm',
          );
        },
        child: IconTheme(
          data: IconThemeData(color: Colors.black),
          child: Icon(Icons.share),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('STATISTICS', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Stats(data: points, title: 'POINTS')),
          Expanded(child: Stats(data: total, title: 'DECIMALS')),
          Expanded(
            child: Stats(
              data: streak,
              title: '️️️️️️️😍❗️️ LONGEST COMBO 👌🍌',
            ),
          ),
        ],
      ),
    );
  }
}
