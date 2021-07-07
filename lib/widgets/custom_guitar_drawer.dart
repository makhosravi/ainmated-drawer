import 'package:complex_ui1/controller/drag_controller.dart';
import 'package:complex_ui1/widgets/my_drawer.dart';
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
  static const Duration toggleDuration = Duration(milliseconds: 250);
  AnimationController? _animationController;
  DragController? _dragController;
  static const double maxSlide = 300;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: toggleDuration,
    );
    _dragController = DragController(
      context: context,
      animationController: _animationController!,
      maxSlide: maxSlide,
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
        onHorizontalDragStart: _dragController!.onDragStart,
        onHorizontalDragUpdate: _dragController!.onDragUpdate,
        onHorizontalDragEnd: _dragController!.onDragEnd,
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
                      child: MyDrawer(
                        width: 300,
                      ),
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
