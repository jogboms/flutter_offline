import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_offline/src/utils.dart' as transformers;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final stream = () => StreamController<ConnectivityResult>();

  late StreamController<ConnectivityResult> values;
  late List<ConnectivityResult> emittedValues;
  late bool valuesCanceled;
  late bool valuesPaused;
  late bool valuesResume;
  late StreamSubscription<ConnectivityResult> subscription;
  // bool isDone;
  late List errors;

  void setupForStreamType(StreamTransformer transformer) {
    emittedValues = <ConnectivityResult>[];
    valuesCanceled = false;
    errors = <dynamic>[];
    // isDone = false;
    values = stream()
      ..onPause = () {
        valuesPaused = true;
      }
      ..onResume = () {
        valuesResume = true;
      }
      ..onCancel = () {
        valuesCanceled = true;
      };
    subscription = values.stream
        .transform<ConnectivityResult>(transformer as StreamTransformer<ConnectivityResult, ConnectivityResult>)
        .listen(emittedValues.add, onError: errors.add, onDone: () {
      // isDone = true;
    });
  }

  group('startWith', () {
    setUp(() {
      setupForStreamType(transformers.startsWith(ConnectivityResult.none));
    });

    test('cancels values', () async {
      await subscription.cancel();
      expect(valuesCanceled, true);
    });

    test('paused/resume values', () async {
      subscription.pause();
      expect(valuesPaused, true);
      subscription.resume();
      expect(valuesResume, true);
    });

    test('addError values', () async {
      values.addError(45);
      await Future(() {});
      expect(errors.length, isNonZero);
    });

    test('outputs initial value', () async {
      await Future(() {});
      expect(emittedValues, [ConnectivityResult.none]);
    });

    test('outputs all values', () async {
      values..add(ConnectivityResult.mobile)..add(ConnectivityResult.wifi);
      await Future(() {});
      expect(emittedValues, [ConnectivityResult.none, ConnectivityResult.mobile, ConnectivityResult.wifi]);
    });

    test('outputs initial when followed by empty stream', () async {
      await values.close();
      expect(emittedValues, [ConnectivityResult.none]);
    });

    // test('closes with values', () async {
    //   expect(isDone, false);
    //   await values.close();
    //   expect(isDone, true);
    // });
  });
}
