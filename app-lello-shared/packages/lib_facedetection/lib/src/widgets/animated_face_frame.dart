import 'package:flutter/material.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

class AnimatedFaceFrame extends StatefulWidget {
  final FaceDetectionState state;
  final Color defaultColor;
  final Size size;

  const AnimatedFaceFrame({
    super.key,
    required this.state,
    required this.defaultColor,
    required this.size,
  });

  @override
  State<AnimatedFaceFrame> createState() => _AnimatedFaceFrameState();
}

class _AnimatedFaceFrameState extends State<AnimatedFaceFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  FaceFrameState? _lastFrameState;
  Color? _lastFrameColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FaceFrameState _getFrameState() {
    _lastFrameState ??= _calculateFrameState();
    final currentState = _calculateFrameState();
    if (_lastFrameState != currentState) {
      _lastFrameState = currentState;
    }
    return _lastFrameState!;
  }

  FaceFrameState _calculateFrameState() {
    if (widget.state is FaceMovingState ||
        widget.state is FaceInitialCenterState) {
      return FaceFrameState.waiting;
    }
    if (widget.state is FaceDetectedState) {
      return FaceFrameState.detected;
    }
    if (widget.state is FaceMovingRightState ||
        widget.state is FaceMovingLeftState ||
        widget.state is FaceMovingUpState ||
        widget.state is FaceMovingDownState ||
        widget.state is FaceMovingSmileState ||
        widget.state is FaceMovingBlinkState) {
      return FaceFrameState.validating;
    }
    if (widget.state is FaceFailureState) {
      return FaceFrameState.error;
    }
    return FaceFrameState.waiting;
  }

  Color _getFrameColor() {
    _lastFrameColor ??= _calculateFrameColor();
    final currentColor = _calculateFrameColor();
    if (_lastFrameColor != currentColor) {
      _lastFrameColor = currentColor;
    }
    return _lastFrameColor!;
  }

  Color _calculateFrameColor() {
    if (widget.state is FaceFailureState) {
      return Colors.red;
    }
    if (widget.state is FaceDetectedState) {
      return Colors.green;
    }
    if (widget.state is FaceMovingRightState ||
        widget.state is FaceMovingLeftState ||
        widget.state is FaceMovingUpState ||
        widget.state is FaceMovingDownState ||
        widget.state is FaceMovingSmileState ||
        widget.state is FaceMovingBlinkState) {
      return Colors.green;
    }
    return widget.defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: widget.size,
          painter: RPSCustomPainter(
            color: _getFrameColor(),
            state: _getFrameState(),
            animation: _animation,
          ),
        );
      },
    );
  }
}
