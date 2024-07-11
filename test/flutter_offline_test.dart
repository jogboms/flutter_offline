import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart' as wifi;

void main() {
  group('Test UI Widget', () {
    testWidgets('Test w/ factory OfflineBuilder', (WidgetTester tester) async {
      final instance = OfflineBuilder(
        connectivityBuilder: (_, __, Widget child) => child,
        builder: (BuildContext context) => const Text('builder_result'),
      );

      expect(instance.connectivityService, isInstanceOf<Connectivity>());
    });

    testWidgets('Test w/ builder param', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: TestConnectivityService([ConnectivityResult.none]),
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, __, Widget child) => child,
          builder: (BuildContext context) => const Text('builder_result'),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('builder_result'), findsOneWidget);
    });

    testWidgets('Test w/ child param', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: TestConnectivityService([ConnectivityResult.none]),
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, __, Widget child) => child,
          child: const Text('child_result'),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('child_result'), findsOneWidget);
    });
  });

  group('Test Assertions', () {
    testWidgets('Test builder & child param', (WidgetTester tester) async {
      expect(() {
        OfflineBuilder.initialize(
          connectivityService: TestConnectivityService([ConnectivityResult.none]),
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, __, Widget child) => child,
          builder: (BuildContext context) => const Text('builder_result'),
          child: const Text('child_result'),
        );
      }, throwsAssertionError);
    });

    testWidgets('Test no builder & child param', (WidgetTester tester) async {
      expect(() {
        OfflineBuilder.initialize(
          connectivityService: TestConnectivityService([ConnectivityResult.none]),
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, __, Widget child) => child,
        );
      }, throwsAssertionError);
    });
  });

  group('Test Status', () {
    testWidgets('Test builder offline', (WidgetTester tester) async {
      const initialConnection = [ConnectivityResult.none];
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: TestConnectivityService(initialConnection),
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          child: const SizedBox(),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text(initialConnection.toString()), findsOneWidget);
    });

    testWidgets('Test builder online', (WidgetTester tester) async {
      const initialConnection = [ConnectivityResult.wifi];
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: TestConnectivityService(initialConnection),
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          child: const SizedBox(),
        ),
      ));
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text(initialConnection.toString()), findsOneWidget);
    });
  });

  group('Test Flipper', () {
    testWidgets('Test builder flips online to offline', (WidgetTester tester) async {
      const initialConnection = [ConnectivityResult.wifi];
      const lastConnection = [ConnectivityResult.none];
      final service = TestConnectivityService(initialConnection);
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: service,
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          child: const SizedBox(),
        ),
      ));

      await tester.pump(kOfflineDebounceDuration);
      expect(find.text(initialConnection.toString()), findsOneWidget);

      service.result = [ConnectivityResult.none];
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text(lastConnection.toString()), findsOneWidget);
    });

    testWidgets('Test builder flips offline to online', (WidgetTester tester) async {
      const initialConnection = [ConnectivityResult.none];
      const lastConnection = [ConnectivityResult.wifi];
      final service = TestConnectivityService(initialConnection);
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: service,
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          child: const SizedBox(),
        ),
      ));

      await tester.pump(kOfflineDebounceDuration);
      expect(find.text(initialConnection.toString()), findsOneWidget);

      service.result = [ConnectivityResult.wifi];
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text(lastConnection.toString()), findsOneWidget);
    });
  });

  group('Test Debounce', () {
    const initialConnection = [ConnectivityResult.none];
    const connections = [
      [ConnectivityResult.wifi],
      [ConnectivityResult.mobile],
      [ConnectivityResult.none],
      [ConnectivityResult.wifi],
    ];
    testWidgets('Test for Debounce: Zero', (WidgetTester tester) async {
      final service = TestConnectivityService(initialConnection);
      const debounceDuration = Duration.zero;
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: service,
          wifiInfo: TestNetworkInfoService(),
          debounceDuration: debounceDuration,
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          child: const SizedBox(),
        ),
      ));

      for (final connection in connections) {
        service.result = connection;
        await tester.pump(debounceDuration);
        expect(find.text(connection.toString()), findsOneWidget);
      }
    });

    testWidgets('Test for Debounce: 5 seconds', (WidgetTester tester) async {
      const debounceDuration = Duration(seconds: 5);

      const initialConnection = [ConnectivityResult.none];
      const actualConnections = [
        [ConnectivityResult.wifi],
        [ConnectivityResult.mobile],
        [ConnectivityResult.none],
        [ConnectivityResult.wifi],
      ];
      const expectedConnections = [
        [ConnectivityResult.none],
        [ConnectivityResult.none],
        [ConnectivityResult.none],
        [ConnectivityResult.wifi],
      ];
      const durations = [
        Duration.zero,
        Duration.zero,
        Duration.zero,
        debounceDuration,
      ];

      final service = TestConnectivityService(initialConnection);
      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: service,
          wifiInfo: TestNetworkInfoService(),
          debounceDuration: debounceDuration,
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) {
            return Text('$connectivity');
          },
          child: const SizedBox(),
        ),
      ));

      for (var i = 0; i < actualConnections.length; i++) {
        service.result = actualConnections[i];
        await tester.pump(durations[i]);
        expect(find.text(expectedConnections[i].toString()), findsOneWidget);
      }
    });
  });

  group('Test Platform Errors', () {
    testWidgets('Test w/o errorBuilder', (WidgetTester tester) async {
      const initialConnection = [ConnectivityResult.none];
      final service = TestConnectivityService(initialConnection);

      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: service,
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          debounceDuration: Duration.zero,
          child: const SizedBox(),
        ),
      ));

      await tester.pump(Duration.zero);
      expect(find.text(initialConnection.toString()), findsOneWidget);

      service.addError();
      await tester.pump(kOfflineDebounceDuration);
      expect(tester.takeException(), isInstanceOf<OfflineBuilderError>());
    });

    testWidgets('Test w/ errorBuilder', (WidgetTester tester) async {
      const initialConnection = [ConnectivityResult.wifi];
      final service = TestConnectivityService(initialConnection);

      await tester.pumpWidget(MaterialApp(
        home: OfflineBuilder.initialize(
          connectivityService: service,
          wifiInfo: TestNetworkInfoService(),
          connectivityBuilder: (_, List<ConnectivityResult> connectivity, __) => Text('$connectivity'),
          debounceDuration: Duration.zero,
          errorBuilder: (context) => const Text('Error'),
          child: const SizedBox(),
        ),
      ));

      await tester.pump(Duration.zero);
      expect(find.text(initialConnection.toString()), findsOneWidget);

      service.addError();
      await tester.pump(kOfflineDebounceDuration);
      expect(find.text('Error'), findsOneWidget);
    });
  });
}

class TestConnectivityService implements Connectivity {
  TestConnectivityService([this.initialConnection]) : _result = initialConnection ?? [ConnectivityResult.none] {
    controller = StreamController<List<ConnectivityResult>>.broadcast(
      onListen: () => controller.add(_result),
    );
  }

  late final StreamController<List<ConnectivityResult>> controller;
  final List<ConnectivityResult>? initialConnection;

  List<ConnectivityResult> _result;

  set result(List<ConnectivityResult> result) {
    _result = result;
    controller.add(result);
  }

  void addError() => controller.addError('Error');

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => controller.stream;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future.delayed(Duration.zero, () => initialConnection!);
  }
}

class TestNetworkInfoService implements wifi.NetworkInfo {
  TestNetworkInfoService();

  @override
  Future<String> getWifiIP() async => '127.0.0.1';

  @override
  Future<String> getWifiName() async => 'Localhost';

  @override
  Future<String> getWifiBSSID() async => '';

  @override
  Future<String?> getWifiBroadcast() async => '127.0.0.255';

  @override
  Future<String?> getWifiGatewayIP() async => '127.0.0.0';

  @override
  Future<String?> getWifiIPv6() async => '2002:7f00:0001:0:0:0:0:0';

  @override
  Future<String?> getWifiSubmask() async => '255.255.255.0';
}
