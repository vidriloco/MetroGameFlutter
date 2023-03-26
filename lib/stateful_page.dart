import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RoutesListPage extends StatefulWidget {
    const RoutesListPage({Key? key, required this.title}) : super(key: key);
    
    final String title;
    
    @override
    State<RoutesListPage> createState() => _RoutesListPageState();
}

class _RoutesListPageState extends State<RoutesListPage> {
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
  }
}