part of flutter_offline;

class OfflineBuilder extends StatefulWidget {
  final OfflineBuilderDelegate delegate;

  const OfflineBuilder({
    Key key,
    @required this.delegate,
  }) : super(key: key);

  @override
  OfflineBuilderState createState() => new OfflineBuilderState();
}

class OfflineBuilderState extends State<OfflineBuilder> {
  final _connectivity = new Connectivity();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
      future: _connectivity.checkConnectivity(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return widget.delegate.waitBuilder(context);
        }
        return new StreamBuilder<ConnectivityResult>(
          initialData: snapshot.data,
          stream: _connectivity.onConnectivityChanged.distinct().asyncMap(
                (event) => Future.delayed(widget.delegate.delay, () => event),
              ),
          builder: (context, snapshot) {
            final _state = snapshot.data != ConnectivityResult.none;

            final _offlineView = _state == false
                ? widget.delegate.offlineBuilder(context, _state)
                : null;

            if (_offlineView != null) {
              return _offlineView;
            }

            return widget.delegate.builder(context, _state);
          },
        );
      },
    );
  }
}
