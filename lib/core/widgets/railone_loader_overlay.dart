import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_assets.dart';

/// Reusable Global Rotating Loader Overlay for RailOne
///
/// Features a dark dimmed barrier (black55) and a continuous 360-degree
/// rotating loader icon matching the official RailOne blue spinner.
class RailOneLoaderOverlay extends StatefulWidget {
  final bool isLoading;
  final Widget? child;
  final double size;

  const RailOneLoaderOverlay({
    super.key,
    this.isLoading = true,
    this.child,
    this.size = 58.0,
  });

  @override
  State<RailOneLoaderOverlay> createState() => _RailOneLoaderOverlayState();
}

class _RailOneLoaderOverlayState extends State<RailOneLoaderOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      if (!widget.isLoading) return const SizedBox.shrink();
      return _buildOverlay();
    }

    return Stack(
      children: [
        widget.child!,
        if (widget.isLoading) _buildOverlay(),
      ],
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.55),
        alignment: Alignment.center,
        child: RotationTransition(
          turns: _rotationController,
          child: AppAssets.safeImage(
            AppAssets.loaderIcon,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: _RailOneSpinnerPainter(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Fallback custom painter for the blue gradient arc loader
class _RailOneSpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6) / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepGradient = SweepGradient(
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: [
        const Color(0xFF0066FF).withOpacity(0.0),
        const Color(0xFF0066FF).withOpacity(0.4),
        const Color(0xFF0066FF),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 1.8, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
