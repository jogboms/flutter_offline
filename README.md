# ✈️ Flutter Offline

[![Format, Analyze and Test](https://github.com/jogboms/flutter_offline/actions/workflows/main.yml/badge.sv- 🔄 Backward compatible)](https://github.com/jogboms/flutter_offline/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/jogboms/flutter_offline/branch/master/graph/badge.svg)](https://codecov.io/gh/jogboms/flutter_offline) [![pub package](https://img.shields.io/pub/v/flutter_offline.svg)](https://pub.dartlang.org/packages/flutter_offline)

A tidy utility to handle offline/online connectivity like a Boss. It provides support for both iOS and Android platforms (offcourse).

## 🎖 Installing

```yaml
dependencies:
  flutter_offline: "^4.0.0"
```

### ⚡️ Import

```dart
import 'package:flutter_offline/flutter_offline.dart';
```

### ✔ Add Permission to Manifest

```dart
<uses-permission android:name="android.permission.INTERNET"/>
```

## 🎮 How To Use

```dart
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Offline Demo"),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          List<ConnectivityResult> connectivity,
          Widget child,
        ) {
          final bool connected = !connectivity.contains(ConnectivityResult.none);
          return new Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                  child: Center(
                    child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                  ),
                ),
              ),
              Center(
                child: new Text(
                  'Yay!',
                ),
              ),
            ],
          );
        },
        child: Column(
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
      ),
    );
  }
}
```

### Network State Management with NetworkNotifier

The package now includes `NetworkNotifier` for event-based network state handling with smart debouncing:

```dart
NetworkNotifier(
  // Optional: Filter specific network states
  filter: (status) => status == ConnectivityResult.mobile,
  
  // Handle network changes
  onNetworkChanged: (context, status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Network changed to: ${status.toString().split('.').last}'),
      ),
    );
  },
  
  // Optional: Customize stability duration and debouncing
  stabilityDuration: Duration(seconds: 2),
  stateDebounce: {
    ConnectivityResult.wifi: Duration(milliseconds: 500),    // Faster for WiFi
    ConnectivityResult.mobile: Duration(seconds: 1),         // Balanced for mobile
    ConnectivityResult.none: Duration(seconds: 2),           // Conservative for disconnection
  },
  
  child: YourWidget(),
)
```

### Key Features

#### OfflineBuilder
- 🎨 UI-focused connectivity handling
- 🔄 Reactive widget rebuilding
- 🎯 Direct access to connectivity state

#### NetworkNotifier
- 🎯 Event-based network monitoring
- 🔍 Filtered network state changes
- ⏱️ Smart debouncing by connection type
- 🧠 Adaptive state management
- 🛡️ Notification spam prevention
- 🎭 Separation of UI and network logic
- ⚡️ Fully configurable
- � Backward compatible

For more info and detailed examples, please refer to the `example` folder.

## 📷 Screenshots

<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/jogboms/flutter_offline/master/screenshots/demo_1.gif" width="250px">
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/jogboms/flutter_offline/master/screenshots/demo_2.gif" width="250px">
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/jogboms/flutter_offline/master/screenshots/demo_3.gif" width="250px">
    </td>
  </tr>
</table>

## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.

### ❗️ Note

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

### 🤓 Mentions

Simon Lightfoot ([@slightfoot](https://github.com/slightfoot)) is just awesome 👍.

## ⭐️ License

MIT License
