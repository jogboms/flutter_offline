import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/src/utils.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'main.dart';

typedef ListenerBuilder<T> = void Function(BuildContext context, T value);
typedef ListenWhen<T> = bool Function(ConnectivityResult);

class OfflineListener extends StatefulWidget {
  factory OfflineListener({
    Key? key,
    required Widget child,
    ListenWhen? listenWhen,
    Duration debounceDuration = kOfflineDebounceDuration,
    ListenerBuilder<ConnectivityResult>? listenerBuilder,
    WidgetBuilder? errorBuilder,
  }) {
    return OfflineListener.initialize(
      key: key,
      connectivityService: Connectivity(),
      wifiInfo: NetworkInfo(),
      debounceDuration: debounceDuration,
      errorBuilder: errorBuilder,
      listenWhen: listenWhen,
      listenerBuilder: listenerBuilder,
      child: child,
    );
  }

  @visibleForTesting
  const OfflineListener.initialize({
    Key? key,
    required this.connectivityService,
    required this.wifiInfo,
    required this.child,
    this.listenWhen,
    this.listenerBuilder,
    this.debounceDuration = kOfflineDebounceDuration,
    this.errorBuilder,
  }) : super(key: key);

  /// Override connectivity service used for testing
  final Connectivity connectivityService;

  /// Specify when to listen
  final ListenWhen? listenWhen;

  /// Listen to new updates on connectivity. Only notifies when listenWhen returns true.
  ///
  /// If listenWhen is null, will listen to all updates.
  final ListenerBuilder<ConnectivityResult>? listenerBuilder;

  final NetworkInfo wifiInfo;

  /// Debounce duration from epileptic network situations
  final Duration debounceDuration;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Used for building the error widget incase of any platform errors
  final WidgetBuilder? errorBuilder;

  @override
  OfflineListenerState createState() => OfflineListenerState();
}

class OfflineListenerState extends State<OfflineListener> {
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();

    _connectivityStream =
        Stream.fromFuture(widget.connectivityService.checkConnectivity())
            .asyncExpand((data) => widget
                .connectivityService.onConnectivityChanged
                .transform(startsWith(data)))
            .transform(debounce(widget.debounceDuration));

    _listenToChanges();
  }

  void _listenToChanges() {
    _connectivityStream.listen((data) {
      if (widget.listenWhen?.call(data) ?? true) {
        widget.listenerBuilder?.call(context, data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class OfflineListenerError extends Error {
  OfflineListenerError(this.error);

  final Object error;

  @override
  String toString() => error.toString();
}
