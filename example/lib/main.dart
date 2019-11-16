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
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(child: Text("Demo 1"), onPressed: () => navigate(context, Demo1())),
          RaisedButton(child: Text("Demo 2"), onPressed: () => navigate(context, Demo2())),
          RaisedButton(child: Text("Demo 3"), onPressed: () => navigate(context, Demo3())),
        ],
      ),
    );
  }

  void navigate(BuildContext context, Widget widget) =>
      Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => DemoPage(child: widget)));
}
