import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Demo'),
      ),
      body: child,
    );
  }
}
