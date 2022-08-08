import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo4 extends StatelessWidget {
  const Demo4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineListener(
      debounceDuration: Duration.zero,
      listenWhen: (c) => c == ConnectivityResult.mobile,
      listenerBuilder: (context, connectivity) {
        // for ex showing a snackbar when using mobile internet if app is downloading something big.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Alert: Switched to mobile internet, consider switching to wifi instead.')));
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'There are no bottons to push :)',
            ),
            Text(
              'Try switching your internet to wifi and mobile data',
            ),
          ],
        ),
      ),
    );
  }
}
