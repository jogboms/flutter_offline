import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Offline Demo"),
      ),
      body: child,
    );
  }
}
