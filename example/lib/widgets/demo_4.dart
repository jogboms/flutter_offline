import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Demo4 extends StatelessWidget {
  const Demo4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NetworkNotifier(
      // Using smart debounce with custom durations
      stateDebounce: const {
        ConnectivityResult.wifi: Duration(milliseconds: 500), // Fast for WiFi
        ConnectivityResult.mobile: Duration(seconds: 1), // Slower for mobile
        ConnectivityResult.none:
            Duration(seconds: 2), // Longest for disconnection
      },
      onNetworkChanged: (context, status) {
        final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(
                status == ConnectivityResult.wifi
                    ? Icons.wifi
                    : status == ConnectivityResult.mobile
                        ? Icons.network_cell
                        : Icons.signal_wifi_off,
                color: status == ConnectivityResult.none
                    ? Colors.red
                    : Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network Status: ${status.toString().split('.').last}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (status == ConnectivityResult.mobile)
                      const Text(
                        'Large data usage may incur charges',
                        style: TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor:
              status == ConnectivityResult.none ? Colors.red.shade900 : null,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'There are no buttons to push :)',
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
