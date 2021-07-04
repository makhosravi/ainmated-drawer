import 'package:complex_ui1/notifier/drawer_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.appbar}) : super(key: key);

  final AppBar appbar;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<DrawerState>(
                  builder: (context, flip, child) {
                    return ElevatedButton(
                      onPressed: () {
                        flip.flip = false;
                      },
                      child: Text(
                        'Custom',
                        style: TextStyle(
                          color: !flip.flip ? Colors.blueAccent : Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            !flip.flip ? Colors.white : Colors.blueAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side:
                                BorderSide(width: 2, color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Consumer<DrawerState>(
                  builder: (context, flip, child) {
                    return ElevatedButton(
                      onPressed: () {
                        flip.flip = true;
                      },
                      child: Text(
                        'Guitar',
                        style: TextStyle(
                            color:
                                flip.flip ? Colors.blueAccent : Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            flip.flip ? Colors.white : Colors.blueAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
