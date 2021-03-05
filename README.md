# ✈️ Flutter Offline

[![Build Status - Travis](https://travis-ci.org/jogboms/flutter_offline.svg?branch=master)](https://travis-ci.org/jogboms/flutter_offline) [![codecov](https://codecov.io/gh/jogboms/flutter_offline/branch/master/graph/badge.svg)](https://codecov.io/gh/jogboms/flutter_offline) [![pub package](https://img.shields.io/pub/v/flutter_offline.svg)](https://pub.dartlang.org/packages/flutter_offline)

A tidy utility to handle offline/online connectivity like a Boss. It provides support for both iOS and Android platforms (offcourse).

## 🎖 Installing

```yaml
dependencies:
  flutter_offline: "^2.0.0"
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
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
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

For more info, please, refer to the `main.dart` in the example.

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
