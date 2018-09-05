import 'package:example/delegates/demo_1.dart';
import 'package:example/demo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

void main() => runApp(new MyApp());

void navigate(BuildContext context, OfflineBuilderDelegate delegate) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new DemoPage(
          delegate: delegate,
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Offline Demo',
      theme: new ThemeData.dark(),
      home: Builder(
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Demo 1"),
                onPressed: () {
                  navigate(context, Demo1OfflineDelegate());
                },
              ),
              RaisedButton(
                child: Text("Demo 2"),
                onPressed: () {
                  navigate(context, Demo1OfflineDelegate());
                },
              ),
              RaisedButton(
                child: Text("Demo 3"),
                onPressed: () {
                  navigate(context, Demo1OfflineDelegate());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
