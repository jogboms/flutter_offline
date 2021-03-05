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
  final stream = () => StreamController<ConnectivityResult>.broadcast();

  group('Group', () {
    late StreamController<ConnectivityResult> values;
    late List emittedValues;
    late bool valuesCanceled;
    late bool isDone;
    late List errors;
    late StreamSubscription subscription;
    late Stream transformed;

    void setUpStreams(StreamTransformer transformer) {
      valuesCanceled = false;
      values = stream()
        ..onCancel = () {
          valuesCanceled = true;
        };
      emittedValues = <ConnectivityResult>[];
      errors = <ConnectivityResult>[];
      isDone = false;
      transformed = values.stream.transform<void>(transformer as StreamTransformer<ConnectivityResult, void>);
      subscription = transformed.listen(emittedValues.add, onError: errors.add, onDone: () {
        isDone = true;
      });
    }

    group('debounce', () {
      setUp(() async {
        setUpStreams(debounce(const Duration(milliseconds: 5)));
      });

      test('cancels values', () async {
        await subscription.cancel();
        expect(valuesCanceled, true);
      });

      test('swallows values that come faster than duration', () async {
        values.add(ConnectivityResult.mobile);
        values.add(ConnectivityResult.wifi);
        await values.close();
        await waitForTimer(5);
        expect(emittedValues, [ConnectivityResult.mobile]);
      });

      test('outputs multiple values spaced further than duration', () async {
        values.add(ConnectivityResult.mobile);
        await waitForTimer(5);
        values.add(ConnectivityResult.wifi);
        await waitForTimer(5);
        expect(
          emittedValues,
          [ConnectivityResult.mobile, ConnectivityResult.wifi],
        );
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
