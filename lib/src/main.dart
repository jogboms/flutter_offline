import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/src/utils.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

const kOfflineDebounceDuration = Duration(seconds: 3);
typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T value, Widget child);

class OfflineBuilder extends StatefulWidget {
  factory OfflineBuilder({
    Key? key,
    required ValueWidgetBuilder<ConnectivityResult> connectivityBuilder,
    Duration debounceDuration = kOfflineDebounceDuration,
    WidgetBuilder? builder,
    Widget? child,
    WidgetBuilder? errorBuilder,
  }) {
    return OfflineBuilder.initialize(
      key: key,
      connectivityBuilder: connectivityBuilder,
      connectivityService: Connectivity(),
      wifiInfo: WifiInfo(),
      debounceDuration: debounceDuration,
      builder: builder,
      errorBuilder: errorBuilder,
      child: child,
    );
  }

  @visibleForTesting
  OfflineBuilder.initialize({
    Key? key,
    required this.connectivityBuilder,
    required this.connectivityService,
    required this.wifiInfo,
    this.debounceDuration = kOfflineDebounceDuration,
    this.builder,
    this.child,
    this.errorBuilder,
  })  : assert(!(builder is WidgetBuilder && child is Widget) && !(builder == null && child == null),
            'You should specify either a builder or a child'),
        super(key: key);

  /// Override connectivity service used for testing
  final Connectivity connectivityService;

  final WifiInfo wifiInfo;

  /// Debounce duration from epileptic network situations
  final Duration debounceDuration;

  /// Used for building the Offline and/or Online UI
  final ValueWidgetBuilder<ConnectivityResult> connectivityBuilder;

  /// Used for building the child widget
  final WidgetBuilder? builder;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Used for building the error widget incase of any platform errors
  final WidgetBuilder? errorBuilder;

  @override
  OfflineBuilderState createState() => OfflineBuilderState();
}

class OfflineBuilderState extends State<OfflineBuilder> {
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();

    _connectivityStream = Stream.fromFuture(widget.connectivityService.checkConnectivity())
        .asyncExpand((data) => widget.connectivityService.onConnectivityChanged.transform(startsWith(data)))
        .transform(debounce(widget.debounceDuration));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const SizedBox();
        }

        if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context);
          }
          throw OfflineBuilderError(snapshot.error!);
        }

        return widget.connectivityBuilder(context, snapshot.data!, widget.child ?? widget.builder!(context));
      },
    );
  }
}

class OfflineBuilderError extends Error {
  OfflineBuilderError(this.error);

  final Object error;

  @override
  String toString() => error.toString();
}
