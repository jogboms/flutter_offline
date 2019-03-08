import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline/src/utils.dart';

const kOfflineDebounceDuration = Duration(seconds: 3);
const kHostToCheck = 'google.com';

class OfflineBuilder extends StatefulWidget {
  factory OfflineBuilder({
    Key key,
    @required ValueWidgetBuilder<ConnectivityResult> connectivityBuilder,
    Duration debounceDuration = kOfflineDebounceDuration,
    String hostToCheck = kHostToCheck,
    bool checkHost = false,
    WidgetBuilder builder,
    Widget child,
    WidgetBuilder errorBuilder,
  }) {
    return OfflineBuilder.initialize(
      key: key,
      connectivityBuilder: connectivityBuilder,
      connectivityService: Connectivity(),
      debounceDuration: debounceDuration,
      hostToCheck: hostToCheck,
      checkHost: checkHost,
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
    this.hostToCheck = kHostToCheck,
    this.checkHost = false,
    this.builder,
    this.child,
    this.errorBuilder,
  })  : assert(connectivityBuilder != null, 'connectivityBuilder cannot be null'),
        assert(debounceDuration != null, 'debounceDuration cannot be null'),
        assert(connectivityService != null, 'connectivityService cannot be null'),
        assert(!(builder is WidgetBuilder && child is Widget) && !(builder == null && child == null),
            'You should specify either a builder or a child'),
        assert(hostToCheck != null, 'hostToCheck cannot be null'),
        assert(checkHost != null, 'checkHost can only be true or false'),
        super(key: key);

  /// Override connectivity service used for testing
  final Connectivity connectivityService;

  /// Debounce duration from epileptic network situations
  final Duration debounceDuration;

  /// Hostname to test internet connection
  final String hostToCheck;

  /// Decide if to use the hostname option
  final bool checkHost;

  /// Used for building the Offline and/or Online UI
  final ValueWidgetBuilder<ConnectivityResult> connectivityBuilder;

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

    _connectivityStream = Stream.fromFuture(widget.connectivityService.checkConnectivity())
        .asyncExpand((data) => widget.connectivityService.onConnectivityChanged.transform(startsWith(data)));

    if (widget.checkHost) {
      _connectivityStream = _connectivityStream.transform(checkIfHostIsAvailble(widget.hostToCheck));
    }

    _connectivityStream = _connectivityStream.transform(debounce(widget.debounceDuration));
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
            return widget.errorBuilder(context);
          }
          throw OfflineBuilderError(snapshot.error);
        }

        return widget.connectivityBuilder(context, snapshot.data, widget.child ?? widget.builder(context));
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
