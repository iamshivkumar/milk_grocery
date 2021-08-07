import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef HomeBuilder<S> = Widget Function(
  BuildContext context,
  VoidCallback open,
);

typedef DrawerBuilder<S> = Widget Function(
  BuildContext context,
  VoidCallback close,
);

class DrawerAnimation extends HookWidget {
  DrawerAnimation({
    required this.homeBuilder,
    required this.drawerBuilder,
    Key? key,
  }) : super(key: key);

  final HomeBuilder homeBuilder;
  final DrawerBuilder drawerBuilder;
  @override
  Widget build(BuildContext context) {
    final _animationController =
        useAnimationController(duration: Duration(milliseconds: 250));
    final width = MediaQuery.of(context).size.width;
    final double maxSlide = width * 2 / 3;
    final double minDragStartEdge = 60;
    final double maxDragStartEdge = maxSlide - 16;
    bool _canBeDragged = false;
    void close() => _animationController.reverse();
    void open() => _animationController.forward();
    void _onDragStart(DragStartDetails details) {
      bool isDragOpenFromLeft = _animationController.isDismissed &&
          details.globalPosition.dx < minDragStartEdge;
      bool isDragCloseFromRight = _animationController.isCompleted &&
          details.globalPosition.dx > maxDragStartEdge;
      _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
    }

    void _onDragUpdate(DragUpdateDetails details) {
      if (_canBeDragged) {
        double delta = details.primaryDelta! / maxSlide;
        _animationController.value += delta;
      }
    }

    void _onDragEnd(DragEndDetails details) {
      double _kMinFlingVelocity = 365.0;
      if (_animationController.isDismissed ||
          _animationController.isCompleted) {
        return;
      }
      if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
        double visualVelocity = details.velocity.pixelsPerSecond.dx /
            MediaQuery.of(context).size.width;
        _animationController.fling(velocity: visualVelocity);
      } else if (_animationController.value < 0.5) {
        close();
      } else {
        open();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
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
          animation: _animationController,
          child: homeBuilder(context, open),
          builder: (context, child) {
            double animValue = _animationController.value;
            final slideAmount = maxSlide * animValue;
            final contentScale = 1.0 - (0.3 * animValue);
            return Stack(
              children: <Widget>[
                drawerBuilder(context, close),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale, contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _animationController.isCompleted ? close : null,
                    child: IgnorePointer(
                      child: child,
                      ignoring: slideAmount == 0 ? false : true,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
