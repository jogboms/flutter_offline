import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';


void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Offline Demo',
			theme: new ThemeData.dark(),
			home: Builder(
				builder: (BuildContext context) {
					return Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							RaisedButton(
								child: Text("Demo 1"),
								onPressed: () {
									navigate(context, _buildDemo1);
								},
							),
							RaisedButton(
								child: Text("Demo 2"),
								onPressed: () {
									navigate(context, _buildDemo2);
								},
							),
							RaisedButton(
								child: Text("Demo 3"),
								onPressed: () {
									navigate(context, _buildDemo3);
								},
							),
						],
					);
				},
			),
		);
	}

	void navigate(BuildContext context, WidgetBuilder builder) {
		Navigator.of(context).push<void>(
			MaterialPageRoute<void>(
				builder: (BuildContext context) {
					return DemoPage(bodyBuilder: builder);
				},
			),
		);
	}

	Widget _buildDemo1(BuildContext context) {
		return OfflineBuilder(
			connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
				final bool connected = connectivity != ConnectivityResult.none;
				return Stack(
					fit: StackFit.expand,
					children: [
						child,
						Positioned(
							height: 32.0,
							left: 0.0,
							right: 0.0,
							child: AnimatedContainer(
								duration: const Duration(milliseconds: 350),
								color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
								child: AnimatedSwitcher(
									duration: const Duration(milliseconds: 350),
									child: connected ? Text('ONLINE') : Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: <Widget>[
											Text('OFFLINE'),
											SizedBox(width: 8.0),
											SizedBox(
												width: 12.0,
												height: 12.0,
												child: CircularProgressIndicator(
													strokeWidth: 2.0,
													valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
												),
											),
										],
									),
								),
							),
						),
					],
				);
			},
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					new Text(
						'There are no bottons to push :)',
					),
					new Text(
						'Just turn off your internet.',
					),
				],
			),
		);
	}

	Widget _buildDemo2(BuildContext context) {
		return OfflineBuilder(
			connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
				if (connectivity == ConnectivityResult.none) {
					return Container(
						color: Colors.white,
						child: Center(
							child: Text(
								"Oops, \n\nNow we are Offline!",
								style: TextStyle(color: Colors.black),
							),
						),
					);
				} else {
					return child;
				}
			},
			builder: (BuildContext context) {
				return Center(
					child: new Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							new Text(
								'There are no bottons to push :)',
							),
							new Text(
								'Just turn off your internet.',
							),
						],
					),
				);
			},
		);
	}

	Widget _buildDemo3(BuildContext context) {
		return OfflineBuilder(
			debounceDuration: Duration.zero,
			connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
				if (connectivity == ConnectivityResult.none) {
					return Container(
						color: Colors.white70,
						child: Center(
							child: Text(
								"Oops, \n\nWe experienced a Delayed Offline!",
								style: TextStyle(color: Colors.black),
							),
						),
					);
				} else {
					return child;
				}
			},
			child: Center(
				child: new Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						new Text(
							'There are no bottons to push :)',
						),
						new Text(
							'Just turn off your internet.',
						),
						new Text(
							'This one has a bit of a delay.',
						),
					],
				),
			),
		);
	}
}

class DemoPage extends StatelessWidget {
	const DemoPage({
		Key key,
		@required this.bodyBuilder,
	}) : super(key: key);

	final WidgetBuilder bodyBuilder;

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				title: new Text("Offline Demo"),
			),
			body: bodyBuilder(context),
		);
	}
}
