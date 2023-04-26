import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nodeflow/ui/divider_horizontal.dart';
import 'package:nodeflow/ui/divider_vertical.dart';

enum SplitMode {
  absolute, // Split by absolute size
  relative, // Split by relative size
}

class Split extends StatefulWidget {
  final double initialPosition;
  final Axis direction;
  final Widget a, b;
  final SplitMode mode;
  const Split(
      {Key? key,
      this.initialPosition = 0.5,
      this.direction = Axis.horizontal,
      required this.a,
      required this.b,
      this.mode = SplitMode.relative})
      : super(key: key);

  @override
  _SplitState createState() => _SplitState();
}

class _SplitState extends State<Split> {
  static const double draggerSize = 5;
  late double _split;
  double _minLeft = 0;
  double _minRight = 0;

  @override
  void initState() {
    super.initState();
    _split = widget.initialPosition;
    if (widget.mode == SplitMode.absolute) {
      if (widget.a is PreferredSizeWidget) {
        if (widget.direction == Axis.horizontal) {
          _split = (widget.a as PreferredSizeWidget).preferredSize.width;
        } else {
          _split = (widget.a as PreferredSizeWidget).preferredSize.height;
        }
      } else if (widget.b is PreferredSizeWidget) {
        if (widget.direction == Axis.horizontal) {
          _split = (widget.b as PreferredSizeWidget).preferredSize.width;
        } else {
          _split = (widget.b as PreferredSizeWidget).preferredSize.height;
        }
      } else {
        if (widget.a is ConstrainedBox) {
          if (widget.direction == Axis.horizontal) {
            _minLeft = (widget.a as ConstrainedBox).constraints.minWidth;
          } else {
            _minLeft = (widget.a as ConstrainedBox).constraints.minHeight;
          }
          _split = _minLeft;
        }
        if (widget.b is ConstrainedBox) {
          if (widget.direction == Axis.horizontal) {
            _minRight = (widget.b as ConstrainedBox).constraints.minWidth;
          } else {
            _minRight = (widget.b as ConstrainedBox).constraints.minHeight;
          }
        }
      }
    }
  }

  // this will calculate the split position
  // also respect the _minLeft, _maxLeft, _minRight, _maxRight
  double _calculateNewSplit(double maxValue, double value) {
    if (value < _minLeft) {
      return _minLeft;
    }
    if (value > maxValue - _minRight) {
      return maxValue - _minRight;
    }
    return value;
  }

  // creates an invisible dragger that can be dragged to resize the split
  Widget createDragger(Size? size) {
    if (size == null) return Container();
    if (widget.direction == Axis.horizontal) {
      return Positioned(
        top: 0,
        bottom: 0,
        left: widget.mode == SplitMode.relative
            ? size.width * _split.clamp(0, 1) - draggerSize / 2
            : (_split - draggerSize / 2).clamp(0, size.width - draggerSize),
        child: MouseRegion(
          cursor: widget.direction == Axis.horizontal
              ? SystemMouseCursors.resizeLeftRight
              : SystemMouseCursors.resizeUpDown,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              setState(() {
                if (widget.mode == SplitMode.relative) {
                  _split = _calculateNewSplit(
                      size.width, _split + details.delta.dx / size.width);
                } else {
                  _split =
                      _calculateNewSplit(size.width, _split + details.delta.dx);
                }
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: Container(
                width: draggerSize,
              ),
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        left: 0,
        right: 0,
        top: widget.mode == SplitMode.relative
            ? size.height * _split.clamp(0, 1) - draggerSize / 2
            : (_split - draggerSize / 2).clamp(0, size.height - draggerSize),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: (details) {
            setState(() {
              if (widget.mode == SplitMode.relative) {
                _split = _calculateNewSplit(
                    size.height, _split + details.delta.dy / size.height);
              } else {
                _split =
                    _calculateNewSplit(size.height, _split + details.delta.dy);
              }
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUpDown,
            child: Container(
              height: draggerSize,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: widget.direction == Axis.horizontal
                ? Row(children: [
                    SizedBox(
                      width: max(
                          0,
                          (widget.mode == SplitMode.relative
                                  ? constraints.maxWidth * _split.clamp(0, 1)
                                  : _split.clamp(0, constraints.maxWidth)) -
                              1),
                      child: widget.a,
                    ),
                    const DividerVertical(),
                    Expanded(child: widget.b),
                  ])
                : Column(
                    children: [
                      SizedBox(
                        height: max(
                            0,
                            (widget.mode == SplitMode.relative
                                    ? constraints.maxHeight * _split.clamp(0, 1)
                                    : _split.clamp(0, constraints.maxHeight)) -
                                1),
                        child: widget.a,
                      ),
                      const DividerHorizontal(),
                      Expanded(child: widget.b),
                    ],
                  ),
          ),
          createDragger(constraints.biggest),
        ],
      );
    });
  }
}
