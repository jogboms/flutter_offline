import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo1 extends StatelessWidget {
  const Demo1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        List<ConnectivityResult> connectivity,
        Widget child,
      ) {
        final connected = !connectivity.contains(ConnectivityResult.none);
        return Stack(
          fit: StackFit.expand,
          children: [
            child,
            Positioned(
              height: 32.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                color: connected ? const Color(0xFF00EE44) : const Color(0xFFEE4400),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: connected
                      ? const Text('ONLINE')
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('OFFLINE'),
                            SizedBox(width: 8.0),
                            SizedBox(
                              width: 12.0,
                              height: 12.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      },
      child: const Column(
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
  }
}
