import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

typedef NetworkCallback = void Function(
    BuildContext context, ConnectivityResult status);
typedef NetworkFilter = bool Function(ConnectivityResult status);

abstract class NetworkMonitor {
  const NetworkMonitor();

  Future<ConnectivityResult> checkConnectivity();
  Stream<ConnectivityResult> get onConnectivityChange;
}

class DefaultNetworkMonitor implements NetworkMonitor {
  const DefaultNetworkMonitor();

  static final Connectivity _connectivity = Connectivity();

  @override
  Future<ConnectivityResult> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return results.first;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChange =>
      _connectivity.onConnectivityChanged.map((list) => list.first);
}

class NetworkNotifier extends StatefulWidget {
  const NetworkNotifier({
    super.key,
    required this.child,
    this.filter,
    this.onNetworkChanged,
    this.stabilityDuration = const Duration(seconds: 3),
    this.stateDebounce = const {
      ConnectivityResult.wifi: Duration(seconds: 1),
      ConnectivityResult.mobile: Duration(seconds: 2),
      ConnectivityResult.none: Duration(seconds: 3),
    },
    NetworkMonitor? monitor,
  }) : _monitor = monitor ?? const DefaultNetworkMonitor();

  final Widget child;
  final NetworkFilter? filter;
  final NetworkCallback? onNetworkChanged;
  final Duration stabilityDuration;
  final Map<ConnectivityResult, Duration> stateDebounce;
  final NetworkMonitor _monitor;

  @override
  State<NetworkNotifier> createState() => _NetworkNotifierState();
}

class _NetworkNotifierState extends State<NetworkNotifier> {
  StreamSubscription<ConnectivityResult>? _subscription;
  ConnectivityResult? _lastStatus;
  Timer? _debounceTimer;
  int _changeCount = 0;

  @override
  void initState() {
    super.initState();
    _changeCount = 0;
    _initializeNetworkMonitoring();
  }

  void _initializeNetworkMonitoring() async {
    // Get initial status
    _lastStatus = await widget._monitor.checkConnectivity();

    // Notify of initial status
    if (widget.filter?.call(_lastStatus!) ?? true) {
      // ignore: use_build_context_synchronously
      widget.onNetworkChanged?.call(context, _lastStatus!);
    }

    // Start monitoring changes
    _subscription =
        widget._monitor.onConnectivityChange.listen(_handleNetworkChange);
  }

  void _handleNetworkChange(ConnectivityResult newStatus) {
    // Cancel any pending timer
    _debounceTimer?.cancel();

    // Calculate adaptive duration based on connection type and change frequency
    final baseDuration =
        widget.stateDebounce[newStatus] ?? widget.stabilityDuration;
    final adaptiveDuration = _changeCount > 3
        ? baseDuration * 1.5 // Increase debounce if many changes
        : baseDuration;

    // Start a new timer with adaptive duration
    _debounceTimer = Timer(adaptiveDuration, () {
      // Only notify if status actually changed
      if (_lastStatus != newStatus) {
        _lastStatus = newStatus;
        _changeCount = 0; // Reset counter after successful change
        if (widget.filter?.call(newStatus) ?? true) {
          widget.onNetworkChanged?.call(context, newStatus);
        }
      }
    });

    _changeCount++; // Increment counter
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _subscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
