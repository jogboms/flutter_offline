import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';

typedef Widget OfflineWidgetBuilder(BuildContext context, bool snapshot);

class OfflineBuilder extends StatefulWidget {
  final OfflineWidgetBuilder builder;

  const OfflineBuilder({
    Key key,
    @required this.builder,
  }) : super(key: key);

  @override
  OfflineBuilderState createState() {
    return new OfflineBuilderState();
  }
}

class OfflineBuilderState extends State<OfflineBuilder> {
  @override
  Widget build(BuildContext context) {
    final _connectivity = new Connectivity();
    return FutureBuilder<ConnectivityResult>(
      future: _connectivity.checkConnectivity(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("wait..."));
        }
        return new StreamBuilder<ConnectivityResult>(
          initialData: snapshot.data,
          stream: _connectivity.onConnectivityChanged,
          builder: (BuildContext context, snapshot) {
            final _state = snapshot.data != ConnectivityResult.none;

            return Center(
              child: Container(
                height: 250.0,
                width: 250.0,
                color: _state ? Color(0xFF00EE44) : Color(0xFFEE4400),
                child: Center(
                  child: Text("${_state.toString()}"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
