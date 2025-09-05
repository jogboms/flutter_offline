import 'package:flutter/material.dart';

import './demo_page.dart';
import './widgets/demo_1.dart';
import './widgets/demo_2.dart';
import './widgets/demo_3.dart';
import './widgets/demo_4.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
                  navigate(context, const Demo1());
                },
                child: const Text('Demo 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  navigate(context, const Demo2());
                },
                child: const Text('Demo 2'),
              ),
              ElevatedButton(
                onPressed: () {
                  navigate(context, const Demo3());
                },
                child: const Text('Demo 3'),
              ),
              ElevatedButton(
                onPressed: () {
                  navigate(context, const Demo4());
                },
                child: const Text('Demo 4'),
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
