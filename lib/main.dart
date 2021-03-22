import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Alert',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Alerta de velocidad'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var timer;
  var _speed = 'Cargando';
  var _speedAccuracy = 'Cargando';
  var counter = 0;
  var _timer;

  void _getPosition() async {
    //desiredAccuracy: LocationAccuracy.high, distanceFilter: 10
    Geolocator.getPositionStream().listen((position) {
      setState(() {
        _speed = position.speed.toStringAsPrecision(2) + ' m/s';
        _speedAccuracy = position.speedAccuracy.toStringAsPrecision(2);

        _timer = counter++;

        if (position.speed >= 0.5) {
          _vibrate();
        }
      });
    });
  }

  void _startCounter() async {
    _getPosition();
    /*const oneSec = const Duration(seconds: 2);
    timer = new Timer.periodic(oneSec, (Timer t) => {
      _getPosition()
    });
    */
  }

  void _cancelCounter() async {
    timer.cancel();
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.bug_report),
                onPressed:_vibrate,
                color: Colors.green
            ),
            IconButton(
                icon: Icon(Icons.stop),
                onPressed:_cancelCounter,
                color: Colors.red
            ),
            Text(
              'Velocidad: $_speed',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Exactitud: $_speedAccuracy',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Tiempo: $_timer',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startCounter,
        tooltip: 'Increment',
        child: Icon(Icons.speed),
        backgroundColor: Colors.red,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
