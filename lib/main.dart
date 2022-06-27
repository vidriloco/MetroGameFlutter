import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder> {
        '/a': (BuildContext context) => MyHomePage(title: 'Patrick'),
        '/b': (BuildContext context) => MyHomePage(title: 'Nandin'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  bool shouldDisplayButton = true;

  void _toggle() {
    setState(() {
      shouldDisplayButton = !shouldDisplayButton;
    });
  }

    void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  Widget _resetCountButtonChild() {
    return CupertinoButton(
      onPressed: _reset,
      child: const Text('Reset count button'),
    );
  }

  Widget _getToggleButtonChild() {
    return CupertinoButton(
      onPressed: _toggle,
      child: const Text('Hide/Show button'),
    );
  }

  Widget _getIncrementButtonChild() {
    if (!shouldDisplayButton) {
      return Container();
    }

    return CupertinoButton(
      onPressed: _incrementCounter,
      child: const Text('Increment counter'),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0));
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _goToOtherScreen() {
    Navigator.of(context).pushNamed('/a');
  }

  /*@override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            _resetCountButtonChild(),
            _getToggleButtonChild(),
            _getIncrementButtonChild(),
            CupertinoButton(
              onPressed: _goToOtherScreen,
              child: const Text('Go to next page'),
              padding: const EdgeInsets.only(left: 10.0, right: 10.0))
          ],
        ),
      ),
    );
  }*/

  Widget buildMap() {
    final String token = 'pk.eyJ1Ijoidmlkcmlsb2NvIiwiYSI6Ik1QRzIwZmcifQ.BzdjvFURAZ8uJ6kNovrrDA';
    final String style = 'mapbox://styles/vidriloco/ckw460ag81rxb15o4cbwyvq1s';

    return MapboxMap(
      accessToken: token,
      styleString: style,
      initialCameraPosition: CameraPosition(
        zoom: 15.0,
        target: LatLng(19.432, -99.133),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            color: Colors.blue,
            child: buildMap()
          ),
        Positioned(
          left: 0,
          right: 0,
          top: 20,
          child: buildNavigationBar(context),
        ),
      ]);
  }

  Widget buildNavigationBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 10),
                child: Image.network('https://cdn.jim-nielsen.com/ios/512/tsukis-odyssey-2021-09-23.png', width: 40, height: 40)
              ),
              Container(
               child: Text('Pridefully', style: TextStyle(
                 fontSize: 25, 
                 color: Colors.white, 
                 fontFamily: 'Nunito',
                 fontStyle: FontStyle.italic,
                 fontWeight: FontWeight.bold))
              )
            ]
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 15, bottom: 10),
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Menu',
              ),
              color: Colors.white,
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: const Text('AlertDialog description'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: buildBody(context)
    );
  }

}
