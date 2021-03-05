import 'dart:async';

import 'package:connectivity/connectivity.dart';

StreamTransformer<ConnectivityResult, ConnectivityResult> debounce(
  Duration debounceDuration,
) {
  var _seenFirstData = false;
  Timer? _debounceTimer;

  return StreamTransformer<ConnectivityResult, ConnectivityResult>.fromHandlers(
    handleData: (ConnectivityResult data, EventSink<ConnectivityResult> sink) {
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

StreamTransformer<ConnectivityResult, ConnectivityResult> startsWith(
  ConnectivityResult data,
) {
  return StreamTransformer<ConnectivityResult, ConnectivityResult>(
    (
      Stream<ConnectivityResult> input,
      bool cancelOnError,
    ) {
      StreamController<ConnectivityResult>? controller;
      late StreamSubscription<ConnectivityResult> subscription;

      controller = StreamController<ConnectivityResult>(
        sync: true,
        onListen: () => controller?.add(data),
        onPause: ([Future<dynamic>? resumeSignal]) => subscription.pause(resumeSignal),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel(),
      );

      subscription = input.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
        cancelOnError: cancelOnError,
      );

      return controller.stream.listen(null);
    },
  );
}
