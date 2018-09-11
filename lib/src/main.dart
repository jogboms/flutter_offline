import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';

const kOfflineDebounceDuration = const Duration(seconds: 3);

typedef Widget ConnectivityBuilder(
    BuildContext context, ConnectivityResult connectivity, Widget child);

abstract class ConnectivityService {
  Stream<ConnectivityResult> get onConnectivityChanged;
}

class OfflineBuilder extends StatefulWidget {
  OfflineBuilder({
    Key key,
    @required this.connectivityBuilder,
    this.connectivityService,
    this.debounceDuration = kOfflineDebounceDuration,
    this.builder,
    this.child,
    this.errorBuilder,
  })  : assert(
            connectivityBuilder != null, 'connectivityBuilder cannot be null'),
        assert(debounceDuration != null, 'debounceDuration cannot be null'),
        assert(
            !(builder is WidgetBuilder && child is Widget) &&
                !(builder == null && child == null),
            'You should specify either a builder or a child'),
        super(key: key);

  /// Override connectivity service used for testing
  final ConnectivityService connectivityService;

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
  bool _seenFirstData = false;
  Timer _debounceTimer;

  @override
  void initState() {
    super.initState();
    Stream<ConnectivityResult> stream;
    if (widget.connectivityService != null) {
      stream = widget.connectivityService.onConnectivityChanged;
    } else {
      stream = Connectivity().onConnectivityChanged;
    }
    _connectivityStream = stream.distinct().transform(StreamTransformer
            .fromHandlers<ConnectivityResult, ConnectivityResult>(
          handleData:
              (ConnectivityResult data, EventSink<ConnectivityResult> sink) {
            if (_seenFirstData) {
              _debounceTimer?.cancel();
              _debounceTimer =
                  Timer(widget.debounceDuration, () => sink.add(data));
            } else {
              sink.add(data);
              _seenFirstData = true;
            }
          },
          handleDone: (EventSink<ConnectivityResult> sink) =>
              _debounceTimer?.cancel(),
        ));
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
  final Object error;

  OfflineBuilderError(this.error);

  @override
  String toString() => error.toString();
}
