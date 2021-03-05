import 'package:flutter/material.dart';

import './demo_page.dart';
import './widgets/demo_1.dart';
import './widgets/demo_2.dart';
import './widgets/demo_3.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Demo',
      theme: ThemeData.dark(),
      home: Builder(
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  navigate(context, Demo1());
                },
                child: Text('Demo 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  navigate(context, Demo2());
                },
                child: Text('Demo 2'),
              ),
              ElevatedButton(
                onPressed: () {
                  navigate(context, Demo3());
                },
                child: Text('Demo 3'),
              ),
            ],
          );
        },
      ),
    );
  }

  void navigate(BuildContext context, Widget widget) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DemoPage(child: widget),
      ),
    );
  }
}
