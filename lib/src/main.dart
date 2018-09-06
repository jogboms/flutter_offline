import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


typedef Widget ConnectivityBuilder(BuildContext context,
	ConnectivityResult connectivity, Widget child);

abstract class ConnectivityService {
	Stream<ConnectivityResult> get onConnectivityChanged;
}

class OfflineBuilder extends StatefulWidget {

	const OfflineBuilder({
		Key key,
		this.connectivityService,
		this.debounceDuration = const Duration(seconds: 3),
		@required this.connectivityBuilder,
		this.builder,
		this.child,
	})
		:
	// FIXME assert(builder != null && child != null, 'You can only specify builder or child, not both'),
			super(key: key);

	/// Allows you to override connectivity service
	final ConnectivityService connectivityService;

	final Duration debounceDuration;
	final ConnectivityBuilder connectivityBuilder;
	final WidgetBuilder builder;
	final Widget child;

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
		_connectivityStream = stream
			.distinct()
			.transform(StreamTransformer.fromHandlers<ConnectivityResult, ConnectivityResult>(
			handleData: (ConnectivityResult data, EventSink<ConnectivityResult> sink) {
				if (_seenFirstData) {
					_debounceTimer?.cancel();
					_debounceTimer = Timer(widget.debounceDuration, () => sink.add(data));
				} else {
					sink.add(data);
					_seenFirstData = true;
				}
			},
			handleDone: (EventSink<ConnectivityResult> sink) => _debounceTimer?.cancel(),
		));
	}

	@override
	Widget build(BuildContext context) {
		return StreamBuilder<ConnectivityResult>(
			stream: _connectivityStream,
			builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
				final child = widget.child ?? widget.builder(context);
				if (!snapshot.hasData) {
					return SizedBox();
				} else if (snapshot.hasError) {
					return ErrorWidget(snapshot.error);
				}
				return widget.connectivityBuilder(context, snapshot.data, child);
			},
		);
	}
}
