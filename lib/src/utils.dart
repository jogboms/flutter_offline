import 'dart:async';

import 'package:connectivity/connectivity.dart';

class StreamTransformers {
  StreamTransformer<ConnectivityResult, ConnectivityResult> debounce(
    Duration debounceDuration,
  ) {
    bool _seenFirstData = false;
    Timer _debounceTimer;

    return StreamTransformer<ConnectivityResult,
        ConnectivityResult>.fromHandlers(
      handleData:
          (ConnectivityResult data, EventSink<ConnectivityResult> sink) {
        if (_seenFirstData) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(debounceDuration, () => sink.add(data));
        } else {
          sink.add(data);
          _seenFirstData = true;
        }
      },
      handleDone: (EventSink<ConnectivityResult> sink) {
        _debounceTimer?.cancel();
        sink.close();
      },
    );
  }

  // TODO: should test this
  StreamTransformer<ConnectivityResult, ConnectivityResult> startsWith(
    ConnectivityResult data,
  ) {
    return new StreamTransformer<ConnectivityResult, ConnectivityResult>(
        (Stream<ConnectivityResult> input, bool cancelOnError) {
      StreamController<ConnectivityResult> controller;
      StreamSubscription<ConnectivityResult> subscription;

      controller = new StreamController<ConnectivityResult>(
        sync: true,
        onListen: () {
          try {
            controller.add(data);
          } catch (e, s) {
            controller.addError(e, s);
          }

          subscription = input.listen(controller.add,
              onError: controller.addError,
              onDone: controller.close,
              cancelOnError: cancelOnError);
        },
        onPause: ([Future<dynamic> resumeSignal]) =>
            subscription.pause(resumeSignal),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel(),
      );

      return controller.stream.listen(null);
    });
  }
}
