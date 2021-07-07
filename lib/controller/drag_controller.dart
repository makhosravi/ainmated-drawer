import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class DragController {
  DragController({
    required this.context,
    required this.animationController,
    required this.maxSlide,
    this.minDragStartEdge = 60,
  });

  final BuildContext context;
  final AnimationController animationController;
  final double maxSlide;
  final double? minDragStartEdge;
  bool _canBeDragged = false;

  void close() => animationController.reverse();

  void open() => animationController.forward();

  void toggleDrawer() {
    animationController.isCompleted ? close() : open();
  }

  // decide drag is going to open or close drawer
  void onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge!;
    bool isDragCloseFromRite = animationController.isCompleted &&
        details.globalPosition.dx > maxSlide - 16;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRite;
  }

  // detects how long the pointer has moved
  void onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      animationController.value += delta;
    }
  }

  void onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}
