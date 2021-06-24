import 'package:complex_ui1/custom_drawer.dart';
import 'package:complex_ui1/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(onPressed: CustomDrawer.of(context)!.open, icon: Icon(Icons.menu));
        },
      ),
      title: Text('Custom drawer demo'),
    );
    Widget child = HomePage(
      appbar: appbar,
    );
    child = CustomDrawer(child: child);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: child,
    );
  }
}


