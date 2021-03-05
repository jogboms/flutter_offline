import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Container(
            color: Colors.white70,
            child: Center(
              child: Text(
                'Oops, \n\nWe experienced a Delayed Offline!',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
        return child;
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'There are no bottons to push :)',
            ),
            Text(
              'Just turn off your internet.',
            ),
            Text(
              'This one has a bit of a delay.',
            ),
          ],
        ),
      ),
    );
  }
}
