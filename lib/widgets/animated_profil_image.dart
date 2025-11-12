import 'dart:math' as math;
import 'package:about_me/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedProfileImage extends StatefulWidget {
  final double size;

  const AnimatedProfileImage({super.key, this.size = 400});

  @override
  State<AnimatedProfileImage> createState() => _AnimatedProfileImageState();
}

class _AnimatedProfileImageState extends State<AnimatedProfileImage>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Morphing animation
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _morphController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Provider.of<ThemeProvider>(context).isLightMode;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effects
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFF3B82F6,
                    ).withOpacity(_glowAnimation.value * 0.3),
                    const Color(
                      0xFF8B5CF6,
                    ).withOpacity(_glowAnimation.value * 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),

        // Secondary glow
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size * 0.9,
              height: widget.size * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFF14B8A6,
                    ).withOpacity(_glowAnimation.value * 0.3),
                    const Color(
                      0xFF3B82F6,
                    ).withOpacity(_glowAnimation.value * 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),

        // Profile image with morphing border
        AnimatedBuilder(
          animation: _morphController,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: MorphingBorderPainter(
                progress: _morphController.value,
                isLightMode: isLightMode,
              ),
              child: ClipPath(
                clipper: MorphingClipper(progress: _morphController.value),
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Image.asset(
                    'assets/profile.jpg',
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: widget.size,
                        height: widget.size,
                        color: isLightMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: widget.size * 0.5,
                          color: isLightMode
                              ? Colors.grey[600]
                              : Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class MorphingBorderPainter extends CustomPainter {
  final double progress;
  final bool isLightMode;

  MorphingBorderPainter({required this.progress, required this.isLightMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..color = isLightMode
          ? Colors.black.withOpacity(0.1)
          : Colors.white.withOpacity(0.3);

    final path = _createMorphingPath(size, progress);
    canvas.drawPath(path, paint);

    // Draw shadow/glow
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..color = isLightMode
          ? Colors.white.withOpacity(0.15)
          : Colors.black.withOpacity(0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path, shadowPaint);
  }

  Path _createMorphingPath(Size size, double progress) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    const points = 32;
    final angle = (2 * math.pi) / points;

    for (int i = 0; i <= points; i++) {
      final currentAngle = angle * i;

      // Create morphing effect using sine waves
      final wave1 = math.sin(progress * 2 * math.pi + currentAngle * 3) * 0.08;
      final wave2 = math.cos(progress * 2 * math.pi + currentAngle * 2) * 0.06;
      final wave3 = math.sin(progress * 2 * math.pi - currentAngle) * 0.04;

      final r = radius * (1 + wave1 + wave2 + wave3);

      final x = centerX + r * math.cos(currentAngle);
      final y = centerY + r * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic curves for smooth transitions
        final prevAngle = angle * (i - 1);
        final prevWave1 =
            math.sin(progress * 2 * math.pi + prevAngle * 3) * 0.08;
        final prevWave2 =
            math.cos(progress * 2 * math.pi + prevAngle * 2) * 0.06;
        final prevWave3 = math.sin(progress * 2 * math.pi - prevAngle) * 0.04;
        final prevR = radius * (1 + prevWave1 + prevWave2 + prevWave3);

        final prevX = centerX + prevR * math.cos(prevAngle);
        final prevY = centerY + prevR * math.sin(prevAngle);

        final controlX = (prevX + x) / 2;
        final controlY = (prevY + y) / 2;

        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(MorphingBorderPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        isLightMode != oldDelegate.isLightMode;
  }
}

class MorphingClipper extends CustomClipper<Path> {
  final double progress;

  MorphingClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 - 5; // Slightly smaller for border visibility

    const points = 32;
    final angle = (2 * math.pi) / points;
    final path = Path();

    for (int i = 0; i <= points; i++) {
      final currentAngle = angle * i;

      final wave1 = math.sin(progress * 2 * math.pi + currentAngle * 3) * 0.08;
      final wave2 = math.cos(progress * 2 * math.pi + currentAngle * 2) * 0.06;
      final wave3 = math.sin(progress * 2 * math.pi - currentAngle) * 0.04;

      final r = radius * (1 + wave1 + wave2 + wave3);

      final x = centerX + r * math.cos(currentAngle);
      final y = centerY + r * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevAngle = angle * (i - 1);
        final prevWave1 =
            math.sin(progress * 2 * math.pi + prevAngle * 3) * 0.08;
        final prevWave2 =
            math.cos(progress * 2 * math.pi + prevAngle * 2) * 0.06;
        final prevWave3 = math.sin(progress * 2 * math.pi - prevAngle) * 0.04;
        final prevR = radius * (1 + prevWave1 + prevWave2 + prevWave3);

        final prevX = centerX + prevR * math.cos(prevAngle);
        final prevY = centerY + prevR * math.sin(prevAngle);

        final controlX = (prevX + x) / 2;
        final controlY = (prevY + y) / 2;

        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(MorphingClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}
