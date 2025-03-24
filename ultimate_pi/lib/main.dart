import 'package:flutter/material.dart';

import './pages/training/training.dart';
import './pages/references/references.dart';
import './pages/statistics/statistics.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => SelectPage(),
      '/references': (context) => References(),
      '/training': (context) => Training(),
      '/statistics': (context) => Statistics(),
    },
  ),
);

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.black,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/references');
                },
                child: Text(
                  'HELP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 100.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: Text(
                'STATISTICS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/statistics');
              },
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'GO!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/training');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
