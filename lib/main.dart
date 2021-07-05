import 'package:complex_ui1/widget/custom_drawer.dart';
import 'package:complex_ui1/widget/custom_guitar_drawer.dart';
import 'package:complex_ui1/notifier/counter_state.dart';
import 'package:complex_ui1/notifier/drawer_state.dart';
import 'package:complex_ui1/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DrawerState(),
        ),
        ChangeNotifierProvider(
          create: (_) => CounterState(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool flip = Provider.of<DrawerState>(context, listen: true).flip;
    AppBar appbar = AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
              onPressed: flip
                  ? CustomGuitarDrawer.of(context)!.open
                  : CustomDrawer.of(context)!.open,
              icon: Icon(Icons.menu));
        },
      ),
      title: Text('Custom drawer demo'),
    );
    Widget child = HomePage(
      appbar: appbar,
    );
    child =
        flip ? CustomGuitarDrawer(child: child) : CustomDrawer(child: child);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: child,
    );
  }
}
