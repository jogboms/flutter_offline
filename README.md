# ✈️ Flutter Offline

[![Format, Analyze and Test](https://github.com/jogboms/flutter_offline/actions/workflows/main.yml/badge.svg)](https://github.com/jogboms/flutter_offline/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/jogboms/flutter_offline/branch/master/graph/badge.svg)](https://codecov.io/gh/jogboms/flutter_offline) [![pub package](https://img.shields.io/pub/v/flutter_offline.svg)](https://pub.dartlang.org/packages/flutter_offline)

A tidy utility to handle offline/online connectivity like a Boss. It provides support for all platforms (iOS, Android, Web, macOS, Linux, and Windows).

## 🎖 Installing

```yaml
dependencies:
  flutter_offline: "^6.0.0"
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

For more info, please, refer to the `main.dart` in the example.

## 🔄 Retry Functionality

Manually retry connectivity checks with exponential backoff:

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final OfflineRetryController _retryController;

  @override
  void initState() {
    super.initState();
    _retryController = OfflineRetryController(
      maxRetries: 5,
      retryCooldown: const Duration(seconds: 2),
    );
    _retryController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _retryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      retryController: _retryController,
      connectivityBuilder: (context, connectivity, child) {
        final connected = !connectivity.contains(ConnectivityResult.none);
        return Column(
          children: [
            Text(connected ? 'ONLINE' : 'OFFLINE'),
            if (!connected)
              ElevatedButton(
                onPressed: _retryController.canRetry ? _retryController.retry : null,
                child: Text('Retry (${_retryController.retryCount}/5)'),
              ),
          ],
        );
      },
    );
  }
}
```

### Custom Retry Logic

Override `onRetry()` or `onRetryError()` for custom behavior:

```dart
class CustomRetryController extends OfflineRetryController {
  CustomRetryController() : super(maxRetries: 3);

  @override
  Future<void> onRetry() async {
    print('Retrying connection...');
  }

  @override
  void onRetryError(Object error, StackTrace stackTrace) {
    print('Retry failed: $error');
  }
}
```

**Features:**
- Exponential backoff (1s, 2s, 4s, 8s, 16s)
- Configurable retry limits and cooldown
- Auto-reset on reconnection
- Extends `ChangeNotifier` for reactive UI updates

## 🧪 Testing

Run tests with:
```bash
flutter test
```

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
