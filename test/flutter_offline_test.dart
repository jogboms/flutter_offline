import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test UI Widget", () {
    testWidgets('Test w/ builder param', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: (_, __, Widget child) => child,
          builder: (BuildContext context) => Text('builder_result'),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('builder_result'), findsOneWidget);
    });

    testWidgets('Test w/ child param', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: (_, __, Widget child) => child,
          child: Text('child_result'),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('child_result'), findsOneWidget);
    });
  });

  group("Test Assertions", () {
    testWidgets('Test no debounceDuration param', (WidgetTester tester) async {
      expect(() {
        OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: (_, __, Widget child) => child,
          debounceDuration: null,
          builder: (BuildContext context) => Text('builder_result'),
        );
      }, throwsAssertionError);
    });

    testWidgets('Test no connectivityBuilder param',
        (WidgetTester tester) async {
      expect(() {
        OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: null,
          child: Text('child_result'),
        );
      }, throwsAssertionError);
    });

    testWidgets('Test builder & child param', (WidgetTester tester) async {
      expect(() {
        OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: (_, __, Widget child) => child,
          builder: (BuildContext context) => Text('builder_result'),
          child: Text('child_result'),
        );
      }, throwsAssertionError);
    });

    testWidgets('Test no builder & child param', (WidgetTester tester) async {
      expect(() {
        OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: (_, __, Widget child) => child,
        );
      }, throwsAssertionError);
    });
  });

  group("Test Status", () {
    testWidgets('Test builder offline', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: TestConnectivityService(ConnectivityResult.none),
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);
    });

    testWidgets('Test builder online', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService:
              TestConnectivityService(ConnectivityResult.mobile),
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('ConnectivityResult.mobile'), findsOneWidget);
    });
  });

  group("Test Flipper", () {
    testWidgets('Test builder flips online to offline',
        (WidgetTester tester) async {
      final service = TestConnectivityService(ConnectivityResult.mobile);
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: service,
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
        ),
      ));

      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('ConnectivityResult.mobile'), findsOneWidget);

      service.result = ConnectivityResult.none;
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);
    });

    testWidgets('Test builder flips offline to online',
        (WidgetTester tester) async {
      final service = TestConnectivityService(ConnectivityResult.none);
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: service,
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
        ),
      ));

      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);

      service.result = ConnectivityResult.wifi;
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('ConnectivityResult.wifi'), findsOneWidget);
    });
  });

  group("Test Debounce", () {
    testWidgets('Test for Debounce: Zero', (WidgetTester tester) async {
      final service = TestConnectivityService(ConnectivityResult.none);
      const debounceDuration = Duration.zero;
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: service,
          debounceDuration: debounceDuration,
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
        ),
      ));

      service.result = ConnectivityResult.wifi;
      await tester.pump(debounceDuration);
      expect(find.text('ConnectivityResult.wifi'), findsOneWidget);
      service.result = ConnectivityResult.mobile;
      await tester.pump(debounceDuration);
      expect(find.text('ConnectivityResult.mobile'), findsOneWidget);
      service.result = ConnectivityResult.none;
      await tester.pump(debounceDuration);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);
      service.result = ConnectivityResult.wifi;
      await tester.pump(debounceDuration);
      expect(find.text('ConnectivityResult.wifi'), findsOneWidget);
    });

    testWidgets('Test for Debounce: 5 seconds', (WidgetTester tester) async {
      final service = TestConnectivityService(ConnectivityResult.none);
      const debounceDuration = const Duration(seconds: 5);
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: service,
          debounceDuration: debounceDuration,
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
        ),
      ));

      service.result = ConnectivityResult.wifi;
      await tester.pump(Duration.zero);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);
      service.result = ConnectivityResult.mobile;
      await tester.pump(Duration.zero);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);
      service.result = ConnectivityResult.none;
      await tester.pump(Duration.zero);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);
      service.result = ConnectivityResult.wifi;
      await tester.pump(debounceDuration);
      expect(find.text('ConnectivityResult.wifi'), findsOneWidget);
    });
  });

  group("Test Platform Errors", () {
    testWidgets('Test w/o errorBuilder', (WidgetTester tester) async {
      final service = TestConnectivityService(ConnectivityResult.none);

      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: service,
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          debounceDuration: Duration.zero,
          child: SizedBox(),
        ),
      ));

      await tester.pump(Duration.zero);
      expect(find.text('ConnectivityResult.none'), findsOneWidget);

      service.addError();
      await tester.pump(kOfflineDebounceDuration);
      expect(tester.takeException(), isInstanceOf<OfflineBuilderError>());
    });

    testWidgets('Test w/ errorBuilder', (WidgetTester tester) async {
      final service = TestConnectivityService(ConnectivityResult.wifi);

      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder(
          connectivityService: service,
          connectivityBuilder: (_, ConnectivityResult connectivity, __) =>
              Text('$connectivity'),
          child: SizedBox(),
          debounceDuration: Duration.zero,
          errorBuilder: (context) => Text('Error'),
        ),
      ));

      await tester.pump(Duration.zero);
      expect(find.text('ConnectivityResult.wifi'), findsOneWidget);

      service.addError();
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text("Error"), findsOneWidget);
    });
  });
}

class TestConnectivityService extends ConnectivityService {
  StreamController<ConnectivityResult> _controller;
  ConnectivityResult _result = ConnectivityResult.none;
  final ConnectivityResult initialConnection;

  TestConnectivityService([this.initialConnection]) {
    _result = initialConnection;
    _controller = StreamController.broadcast<ConnectivityResult>(
      onListen: () => _controller.add(_result),
    );
  }

  set result(ConnectivityResult result) {
    _result = result;
    _controller.add(result);
  }

  void addError() {
    _controller.addError('Error');
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => _controller.stream;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    return Future.delayed(Duration.zero, () => initialConnection);
  }
}
