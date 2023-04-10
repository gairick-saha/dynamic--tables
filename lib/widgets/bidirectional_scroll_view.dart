import 'package:flutter/material.dart';

enum ScrollDirection { horizontal, vertical, both }

class BidirectionalScrollView extends StatefulWidget {
  const BidirectionalScrollView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<BidirectionalScrollView> createState() =>
      _BidirectionalScrollViewState();
}

class _BidirectionalScrollViewState extends State<BidirectionalScrollView>
    with SingleTickerProviderStateMixin {
  final GlobalKey _positionedKey = GlobalKey();
  final GlobalKey _childKey = GlobalKey();

  double _velocityFactor = 1.0;
  Offset _initialOffset = Offset(0.0, 0.0);
  ScrollDirection _scrollDirection = ScrollDirection.both;

  double xPos = 0.0;
  double yPos = 0.0;
  double xViewPos = 0.0;
  double yViewPos = 0.0;

  late AnimationController _controller;
  late Animation<Offset> _flingAnimation;

  bool _enableFling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  set initOffset(Offset offset) {
    setState(() {
      _initialOffset = offset;
    });
  }

  set offset(Offset offset) {
    setState(() {
      xViewPos = -offset.dx;
      yViewPos = -offset.dy;
    });
  }

  void _handleFlingAnimation() {
    if (!_enableFling ||
        _flingAnimation.value.dx.isNaN ||
        _flingAnimation.value.dy.isNaN) {
      return;
    }

    double newXPosition = xPos + _flingAnimation.value.dx;
    double newYPosition = yPos + _flingAnimation.value.dy;

    if (newXPosition > _initialOffset.dx) {
      newXPosition = _initialOffset.dx;
    }

    if (newYPosition > _initialOffset.dy) {
      newYPosition = _initialOffset.dy;
    }

    setState(() {
      xViewPos = newXPosition;
      yViewPos = newYPosition;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset position = referenceBox.globalToLocal(details.globalPosition);

    double newXPosition = xViewPos + (position.dx - xPos);
    double newYPosition = yViewPos + (position.dy - yPos);

    if (newXPosition > _initialOffset.dx) {
      newXPosition = _initialOffset.dx;
    }

    if (newYPosition > _initialOffset.dy) {
      newYPosition = _initialOffset.dy;
    }

    setState(() {
      xViewPos = newXPosition;
      yViewPos = newYPosition;
    });

    xPos = position.dx;
    yPos = position.dy;
  }

  void _handlePanDown(DragDownDetails details) {
    _enableFling = false;
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset position = referenceBox.globalToLocal(details.globalPosition);

    xPos = position.dx;
    yPos = position.dy;
  }

  void _handlePanEnd(DragEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    final double velocity = magnitude / 1000;

    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size!).shortestSide;

    xPos = xViewPos;
    yPos = yViewPos;

    _enableFling = true;
    _flingAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: direction * distance * _velocityFactor,
    ).animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: velocity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _handlePanDown,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            key: _positionedKey,
            top: yViewPos,
            left: xViewPos,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
