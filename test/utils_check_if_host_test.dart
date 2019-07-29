import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_offline/src/utils.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> waitForTimer(int milliseconds) => Future<void>(() {
      /* ensure Timer is started*/
    })
        .then<void>(
      (_) => Future<void>.delayed(Duration(milliseconds: milliseconds + 1)),
    );

void main() {
  group('Group', () {
    StreamController<ConnectivityResult> values;
    List emittedValues;
    bool valuesCanceled;
    bool isDone;
    List errors;
    StreamSubscription subscription;

    void setUpStreams(StreamTransformer transformer) {
      final stream = () => StreamController<ConnectivityResult>.broadcast();

      valuesCanceled = false;
      values = stream()..onCancel = () => valuesCanceled = true;
      emittedValues = <ConnectivityResult>[];
      errors = <ConnectivityResult>[];
      isDone = false;
      subscription = values.stream.transform<void>(transformer).listen(
            emittedValues.add,
            onError: errors.add,
            onDone: () => isDone = true,
          );
    }

    void cleanUpStreams() {
      valuesCanceled = null;
      values = null;
      emittedValues = null;
      errors = null;
      isDone = null;
      subscription = null;
    }

    group('when host is ok', () {
      setUp(() async {
        setUpStreams(checkIfHostIsAvailble("127.0.0.1"));
      });

      tearDown(() {
        cleanUpStreams();
      });

      test('cancels values', () async {
        await subscription.cancel();
        expect(valuesCanceled, true);
      });

      test('works as expected', () async {
        values.add(ConnectivityResult.wifi);
        await waitForTimer(5);
        expect(emittedValues, [ConnectivityResult.wifi]);
      });

      test('waits for pending value to close', () async {
        values.add(ConnectivityResult.mobile);
        await waitForTimer(5);
        await values.close();
        await Future(() {});
        expect(isDone, true);
      });
    });

    group('when host is not ok', () {
      setUp(() async {
        setUpStreams(checkIfHostIsAvailble("fake"));
      });

      tearDown(() {
        cleanUpStreams();
      });

      test('cancels values', () async {
        await subscription.cancel();
        expect(valuesCanceled, true);
      });

      test('returns a ConnectivityResult.none', () async {
        values.add(ConnectivityResult.wifi);
        await waitForTimer(5);
        expect(emittedValues, [ConnectivityResult.none]);
      });

      test('waits for pending value to close', () async {
        values.add(ConnectivityResult.mobile);
        await waitForTimer(5);
        await values.close();
        await Future(() {});
        expect(isDone, true);
      });
    });
  });
}
