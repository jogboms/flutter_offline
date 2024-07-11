import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

StreamTransformer<List<ConnectivityResult>, List<ConnectivityResult>> debounce(
  Duration debounceDuration,
) {
  var seenFirstData = false;
  Timer? debounceTimer;

  return StreamTransformer<List<ConnectivityResult>, List<ConnectivityResult>>.fromHandlers(
    handleData: (List<ConnectivityResult> data, EventSink<List<ConnectivityResult>> sink) {
      if (seenFirstData) {
        debounceTimer?.cancel();
        debounceTimer = Timer(debounceDuration, () => sink.add(data));
      } else {
        sink.add(data);
        seenFirstData = true;
      }
    },
    handleDone: (EventSink<List<ConnectivityResult>> sink) {
      debounceTimer?.cancel();
      sink.close();
    },
  );
}

StreamTransformer<List<ConnectivityResult>, List<ConnectivityResult>> startsWith(
  List<ConnectivityResult> data,
) {
  return StreamTransformer<List<ConnectivityResult>, List<ConnectivityResult>>(
    (
      Stream<List<ConnectivityResult>> input,
      bool cancelOnError,
    ) {
      StreamController<List<ConnectivityResult>>? controller;
      late StreamSubscription<List<ConnectivityResult>> subscription;

      controller = StreamController<List<ConnectivityResult>>(
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
