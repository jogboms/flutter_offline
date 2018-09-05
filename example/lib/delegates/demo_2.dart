import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo2OfflineDelegate extends OfflineBuilderDelegate {
  @override
  Widget offlineBuilder(BuildContext context, bool state) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "Oops, Now we are Offline!",
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
        ],
      ),
    );
  }
}
