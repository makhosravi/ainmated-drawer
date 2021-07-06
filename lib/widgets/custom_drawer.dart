import 'package:complex_ui1/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static _CustomDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomDrawerState>();

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 225;
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

  void close() => _animationController!.reverse();

  void open() => _animationController!.forward();

  void toggleDrawer() {
    _animationController!.isCompleted ? close() : open();
  }

  // decide drag is going to open or close drawer
  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController!.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRite = _animationController!.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRite;
  }

  // detects how long the pointer has moved
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
        child: AnimatedBuilder(
          animation: _animationController!,
          child: widget.child,
          builder: (context, child) {
            double animValue = _animationController!.value;
            final slideAmount = maxSlide * animValue;
            final contentScale = 1.0 - (0.3 * animValue);
            return Stack(
              children: [
                MyDrawer(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () =>
                          _animationController!.isCompleted ? close() : null,
                      child: widget.child),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
