import 'package:flutter/widgets.dart';

class LoopTranslateWidget extends StatefulWidget {
  const LoopTranslateWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 5000),
    this.deltaX = 20,
    this.curve = Curves.linear,
    required this.child,
  }) : super(key: key);

  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  @override
  _LoopTranslateWidgetState createState() => _LoopTranslateWidgetState();
}

class _LoopTranslateWidgetState extends State<LoopTranslateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shake(double value) =>
      2 * (0.5 - (0.5 - widget.curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(widget.deltaX * shake(controller.value), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
