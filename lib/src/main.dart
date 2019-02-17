import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/src/utils.dart';

const kOfflineDebounceDuration = const Duration(seconds: 3);

typedef Widget ConnectivityBuilder(
    BuildContext context, ConnectivityResult connectivity, Widget child);

class OfflineBuilder extends StatefulWidget {
  factory OfflineBuilder({
    Key key,
    @required ConnectivityBuilder connectivityBuilder,
    Duration debounceDuration = kOfflineDebounceDuration,
    WidgetBuilder builder,
    Widget child,
    WidgetBuilder errorBuilder,
  }) {
    return OfflineBuilder.initialize(
      key: key,
      connectivityBuilder: connectivityBuilder,
      connectivityService: Connectivity(),
      debounceDuration: debounceDuration,
      builder: builder,
      child: child,
      errorBuilder: errorBuilder,
    );
  }

  @visibleForTesting
  OfflineBuilder.initialize({
    Key key,
    @required this.connectivityBuilder,
    @required this.connectivityService,
    this.debounceDuration = kOfflineDebounceDuration,
    this.builder,
    this.child,
    this.errorBuilder,
  })  : assert(
            connectivityBuilder != null, 'connectivityBuilder cannot be null'),
        assert(debounceDuration != null, 'debounceDuration cannot be null'),
        assert(
            connectivityService != null, 'connectivityService cannot be null'),
        assert(
            !(builder is WidgetBuilder && child is Widget) &&
                !(builder == null && child == null),
            'You should specify either a builder or a child'),
        super(key: key);

  /// Override connectivity service used for testing
  final Connectivity connectivityService;

  /// Debounce duration from epileptic network situations
  final Duration debounceDuration;

  /// Used for building the Offline and/or Online UI
  final ConnectivityBuilder connectivityBuilder;

  /// Used for building the child widget
  final WidgetBuilder builder;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Used for building the error widget incase of any platform errors
  final WidgetBuilder errorBuilder;

  @override
  OfflineBuilderState createState() => OfflineBuilderState();
}

class OfflineBuilderState extends State<OfflineBuilder> {
  Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    final transformers = StreamTransformers();

    _connectivityStream = Stream.fromFuture(
      widget.connectivityService.checkConnectivity(),
    ).asyncExpand(
      (ConnectivityResult data) {
        return widget.connectivityService.onConnectivityChanged.transform(
          transformers.startsWith(data),
        );
      },
    ).transform(
      transformers.debounce(widget.debounceDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<ConnectivityResult> snapshot,
      ) {
        final child = widget.child ?? widget.builder(context);
        if (!snapshot.hasData && !snapshot.hasError) {
          return SizedBox();
        } else if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder(context);
          }
          throw new OfflineBuilderError(snapshot.error);
        }
        return widget.connectivityBuilder(context, snapshot.data, child);
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
