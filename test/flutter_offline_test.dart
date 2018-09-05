import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

	testWidgets('Test builder runs builder param', (WidgetTester tester) async {
		await tester.pumpWidget(MaterialApp(
			home: OfflineBuilder(
				connectivityService: TestConnectivityService(ConnectivityResult.none),
				debounceDuration: Duration.zero,
				connectivityBuilder: (_, __, Widget child) => child,
				builder: (BuildContext context) => Text('builder_result'),
			),
		));
		await tester.pump(Duration.zero);
		expect(find.text('builder_result'), findsOneWidget);
	});

	testWidgets('Test builder passes back child param', (WidgetTester tester) async {
		await tester.pumpWidget(MaterialApp(
			home: OfflineBuilder(
				connectivityService: TestConnectivityService(ConnectivityResult.none),
				debounceDuration: Duration.zero,
				connectivityBuilder: (_, __, Widget child) => child,
				child: Text('child_result'),
			),
		));
		await tester.pump(Duration.zero);
		expect(find.text('child_result'), findsOneWidget);
	});

	testWidgets('Test builder offline', (WidgetTester tester) async {
		await tester.pumpWidget(MaterialApp(
			home: OfflineBuilder(
				connectivityService: TestConnectivityService(ConnectivityResult.none),
				debounceDuration: Duration.zero,
				connectivityBuilder: (_, ConnectivityResult connectivity, __) => Text('$connectivity'),
				child: SizedBox(),
			),
		));
		await tester.pump(Duration.zero);
		expect(find.text('ConnectivityResult.none'), findsOneWidget);
	});

	testWidgets('Test builder online', (WidgetTester tester) async {
		await tester.pumpWidget(MaterialApp(
			home: OfflineBuilder(
				connectivityService: TestConnectivityService(ConnectivityResult.mobile),
				debounceDuration: Duration.zero,
				connectivityBuilder: (_, ConnectivityResult connectivity, __) => Text('$connectivity'),
				child: SizedBox(),
			),
		));
		await tester.pump(Duration.zero);
		expect(find.text('ConnectivityResult.mobile'), findsOneWidget);
	});

	testWidgets('Test builder flips online to offline', (WidgetTester tester) async {
		final service = TestConnectivityService(ConnectivityResult.mobile);
		await tester.pumpWidget(MaterialApp(
			home: OfflineBuilder(
				connectivityService: service,
				debounceDuration: Duration.zero,
				connectivityBuilder: (_, ConnectivityResult connectivity, __) => Text('$connectivity'),
				child: SizedBox(),
			),
		));

		await tester.pump(Duration.zero);
		expect(find.text('ConnectivityResult.mobile'), findsOneWidget);

		service.result = ConnectivityResult.none;
		await tester.pump(Duration.zero);
		expect(find.text('ConnectivityResult.none'), findsOneWidget);
	});

	testWidgets('Test builder flips offline to online', (WidgetTester tester) async {
		final service = TestConnectivityService(ConnectivityResult.none);
		await tester.pumpWidget(MaterialApp(
			home: OfflineBuilder(
				connectivityService: service,
				debounceDuration: Duration.zero,
				connectivityBuilder: (_, ConnectivityResult connectivity, __) => Text('$connectivity'),
				child: SizedBox(),
			),
		));

		await tester.pump(Duration.zero);
		expect(find.text('ConnectivityResult.none'), findsOneWidget);

		service.result = ConnectivityResult.wifi;
		await tester.pump(Duration.zero);
		expect(find.text('ConnectivityResult.wifi'), findsOneWidget);
	});

	// TODO: Add at least 2 tests for debounce

	// TODO: Add test for error display
}


class TestConnectivityService extends ConnectivityService {
	StreamController<ConnectivityResult> _controller;
	ConnectivityResult _result = ConnectivityResult.none;

	TestConnectivityService([ConnectivityResult result]) {
		_result = result;
		_controller = StreamController.broadcast<ConnectivityResult>(
			onListen: () => _controller.add(_result),
		);
	}

	set result(ConnectivityResult result) {
		_result = result;
		_controller.add(result);
	}

	@override
	Stream<ConnectivityResult> get onConnectivityChanged => _controller.stream;
}
