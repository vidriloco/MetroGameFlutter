import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RouteCardItem {

  final String name;
  final String description;
  final String imageURL;

  const RouteCardItem(this.name, this.description, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class RoutesListPage extends StatefulWidget {
    const RoutesListPage({Key? key, required this.title}) : super(key: key);
    
    final String title;
    final List<RouteCardItem> items = const [
      const RouteCardItem("Route departing from Lisse", "A route that will bring you through", ""),
      const RouteCardItem("Route through Noordwijkerhout", "Discover the routes passing by", ""),
    ];

    @override
    State<RoutesListPage> createState() => _RoutesListPageState();
}

class _RoutesListPageState extends State<RoutesListPage> {

  @override
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
        actions: <Widget>[
           new IconButton(
             icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
           ),
         ],
        leading: new Container(),
      ),
      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: widget.items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
          );
        },
      ),
    );
  }
}