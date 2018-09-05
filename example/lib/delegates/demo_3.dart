import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo3OfflineDelegate extends OfflineBuilderDelegate {
  @override
  Duration delay = Duration(seconds: 3);

  @override
  Widget offlineBuilder(BuildContext context, bool state) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Text(
          "Oops, \n\nWe experienced a Delayed Offline!",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget builder(BuildContext context, bool state) {
    return Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'There are no bottons to push :)',
          ),
          new Text(
            'Just turn off your internet.',
          ),
          new Text(
            'This one has a bit of a delay.',
          ),
        ],
      ),
    );
  }
}
