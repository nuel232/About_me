import 'dart:math';
import 'package:flutter/material.dart';

class WavesBackground extends StatefulWidget {
  final Color lineColor;
  final Color backgroundColor;
  final double waveSpeedX;
  final double waveSpeedY;
  final double waveAmpX;
  final double waveAmpY;
  final double xGap;
  final double yGap;

  const WavesBackground({
    super.key,
    this.lineColor = const Color(0x33000000),
    this.backgroundColor = Colors.transparent,
    this.waveSpeedX = 0.0125,
    this.waveSpeedY = 0.005,
    this.waveAmpX = 32.0,
    this.waveAmpY = 16.0,
    this.xGap = 10.0,
    this.yGap = 32.0,
  });

  @override
  State<WavesBackground> createState() => _WavesBackgroundState();
}

class _WavesBackgroundState extends State<WavesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _mousePosition = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        color: widget.backgroundColor,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: WavesPainter(
                lineColor: widget.lineColor,
                time: _controller.value * 1000,
                mousePosition: _mousePosition,
                isHovering: _isHovering,
                waveSpeedX: widget.waveSpeedX,
                waveSpeedY: widget.waveSpeedY,
                waveAmpX: widget.waveAmpX,
                waveAmpY: widget.waveAmpY,
                xGap: widget.xGap,
                yGap: widget.yGap,
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class WavesPainter extends CustomPainter {
  final Color lineColor;
  final double time;
  final Offset mousePosition;
  final bool isHovering;
  final double waveSpeedX;
  final double waveSpeedY;
  final double waveAmpX;
  final double waveAmpY;
  final double xGap;
  final double yGap;

  WavesPainter({
    required this.lineColor,
    required this.time,
    required this.mousePosition,
    required this.isHovering,
    required this.waveSpeedX,
    required this.waveSpeedY,
    required this.waveAmpX,
    required this.waveAmpY,
    required this.xGap,
    required this.yGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final totalLines = (size.width / xGap).ceil() + 1;
    final totalPoints = (size.height / yGap).ceil() + 1;

    for (int i = 0; i < totalLines; i++) {
      final path = Path();
      bool firstPoint = true;

      for (int j = 0; j < totalPoints; j++) {
        final x = i * xGap;
        final y = j * yGap;

        // Perlin noise simulation
        final noise = _perlinNoise(
          (x + time * waveSpeedX) * 0.002,
          (y + time * waveSpeedY) * 0.0015,
        );

        final waveX = cos(noise * 12) * waveAmpX;
        final waveY = sin(noise * 12) * waveAmpY;

        // Mouse interaction effect
        double mouseInfluenceX = 0;
        double mouseInfluenceY = 0;

        if (isHovering) {
          final dx = x - mousePosition.dx;
          final dy = y - mousePosition.dy;
          final distance = sqrt(dx * dx + dy * dy);
          final maxDistance = 175.0;

          if (distance < maxDistance) {
            final influence = 1 - (distance / maxDistance);
            final angle = atan2(dy, dx);
            mouseInfluenceX = cos(angle) * influence * 30;
            mouseInfluenceY = sin(angle) * influence * 30;
          }
        }

        final finalX = x + waveX - mouseInfluenceX;
        final finalY = y + waveY - mouseInfluenceY;

        if (firstPoint) {
          path.moveTo(finalX, finalY);
          firstPoint = false;
        } else {
          path.lineTo(finalX, finalY);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  double _perlinNoise(double x, double y) {
    final xi = x.floor();
    final yi = y.floor();
    final xf = x - xi;
    final yf = y - yi;

    final u = _fade(xf);
    final v = _fade(yf);

    final n00 = _gradient(xi, yi, xf, yf);
    final n01 = _gradient(xi, yi + 1, xf, yf - 1);
    final n10 = _gradient(xi + 1, yi, xf - 1, yf);
    final n11 = _gradient(xi + 1, yi + 1, xf - 1, yf - 1);

    final x1 = _lerp(n00, n10, u);
    final x2 = _lerp(n01, n11, u);

    return _lerp(x1, x2, v);
  }

  double _fade(double t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
  }

  double _lerp(double a, double b, double t) {
    return a + t * (b - a);
  }

  double _gradient(int x, int y, double dx, double dy) {
    final hash = ((x * 374761393) + (y * 668265263)) & 0xFFFFFFFF;
    final h = hash % 4;

    switch (h) {
      case 0:
        return dx + dy;
      case 1:
        return -dx + dy;
      case 2:
        return dx - dy;
      default:
        return -dx - dy;
    }
  }

  @override
  bool shouldRepaint(WavesPainter oldDelegate) {
    return time != oldDelegate.time ||
        mousePosition != oldDelegate.mousePosition ||
        isHovering != oldDelegate.isHovering;
  }
}
