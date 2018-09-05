import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({
    Key key,
    @required this.delegate,
  }) : super(key: key);

  final OfflineBuilderDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Offline Demo"),
      ),
      body: OfflineBuilder(
        delegate: delegate,
      ),
    );
  }
}
