import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sem Benavente',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Hello world'),
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
  int _counter = 0;
  MapController mapController;
  Map<String, LatLng> coords;
  List<Marker> markers;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    mapController = new MapController();
    coords = new Map<String, LatLng>();
    coords.putIfAbsent("FIA", () => new LatLng(-11.99078, -76.84004));
    coords.putIfAbsent("CRAI", () => new LatLng(-11.99230, -76.84117));
    coords.putIfAbsent("Bazar", () => new LatLng(-11.99223, -76.84212));

    markers = new List<Marker>();

    for (var i = 0; i < coords.length; i++) {
      markers.add(new Marker(
          width: 100.0,
          height: 100.0,
          point: coords.values.elementAt(i),
          builder: (ctx) => new Icon(
                Icons.location_pin,
                color: Colors.red,
              )));
    }
  }

  void _showCoord(int index) {
    mapController.move(coords.values.elementAt(index), 18.0);
  }

  List<Widget> _makeButtons() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < coords.length; i++) {
      list.add(new RaisedButton(
        onPressed: () => _showCoord(i),
        child: new Text(coords.keys.elementAt(i)),
      ));
    }
    return list;
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
            new Row(
              children: _makeButtons(),
            ),
            new Flexible(
                child: new FlutterMap(
              mapController: mapController,
              options: new MapOptions(
                  center: new LatLng(-11.9920, -76.8405), zoom: 16.0),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                new MarkerLayerOptions(markers: markers)
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
