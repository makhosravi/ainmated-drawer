import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomDrawer(title: 'Flutter Demo Home Page'),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  static const double maxSlide = 225.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var myDrawer = Container(
      color: Colors.blue,
    );
    var myChild = Container(
      color: Colors.yellow,
    );
    return Stack(
      children: [
        myDrawer,
        Transform(
          transform: Matrix4.identity()
            ..translate(maxSlide)
            ..scale(0.5),
          alignment: Alignment.centerLeft,
          child: myChild,
        ),
      ],
    );
  }
}
