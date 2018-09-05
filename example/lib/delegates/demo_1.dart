import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo1OfflineDelegate extends OfflineBuilderDelegate {
  @override
  Widget builder(BuildContext context, bool state) {
    return new Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          height: 24.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            color: state ? Color(0xFF00EE44) : Color(0xFFEE4400),
            child: Center(
              child: Text("${state ? 'ONLINE' : 'OFFLINE'}"),
            ),
          ),
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      ],
    );
  }
}
