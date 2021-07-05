import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomGuitarDrawer extends StatefulWidget {
  const CustomGuitarDrawer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static _CustomGuitarDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomGuitarDrawerState>();

  @override
  _CustomGuitarDrawerState createState() => _CustomGuitarDrawerState();
}

class _CustomGuitarDrawerState extends State<CustomGuitarDrawer>
    with SingleTickerProviderStateMixin {
  static const double maxSlide = 300;
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  AnimationController? _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: toggleDuration,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void open() => _animationController!.forward();

  void close() => _animationController!.reverse();

  void toggleDrawer() => _animationController!.isCompleted ? close() : open();

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController!.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController!.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      _animationController!.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;
    if (_animationController!.isDismissed ||
        _animationController!.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      _animationController!.fling(velocity: visualVelocity);
    } else if (_animationController!.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController!.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        child: AnimatedBuilder(
          child: widget.child,
          animation: _animationController!,
          builder: (context, child) {
            return Material(
              color: Colors.blueGrey,
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset:
                        Offset(maxSlide * (_animationController!.value - 1), 0),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                            math.pi / 2 * (1 - _animationController!.value)),
                      alignment: Alignment.centerRight,
                      child: MyDrawer(),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(maxSlide * _animationController!.value, 0),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(-math.pi * _animationController!.value / 2),
                      alignment: Alignment.centerLeft,
                      child: widget.child,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Material(
        color: Colors.blueAccent,
        child: SafeArea(
          child: Theme(
            data: ThemeData(
              brightness: Brightness.dark,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('MAKH'),
                  accountEmail: Text('makh@sth.com'),
                  currentAccountPicture: FlutterLogo(),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.new_releases),
                  title: Text('News'),
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Favorites'),
                ),
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Map'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
