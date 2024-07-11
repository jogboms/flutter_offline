import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo2 extends StatelessWidget {
  const Demo2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        List<ConnectivityResult> connectivity,
        Widget child,
      ) {
        if (connectivity.contains(ConnectivityResult.none)) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Oops, \n\nNow we are Offline!',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'There are no bottons to push :)',
              ),
              Text(
                'Just turn off your internet.',
              ),
            ],
          ),
        );
      },
    );
  }
}
