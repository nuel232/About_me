import 'package:about_me/widgets/animated_profil_image.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:about_me/theme/theme_provider.dart';
import 'waves_background.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Provider.of<ThemeProvider>(context).isLightMode;
    final screenHeight = MediaQuery.of(context).size.height;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isMobile = sizingInfo.isMobile;
        final isTablet = sizingInfo.isTablet;

        return Container(
          height: screenHeight,
          child: Stack(
            children: [
              // Waves Background
              Positioned.fill(
                child: WavesBackground(
                  lineColor: isLightMode
                      ? const Color(0x33FFFFFF)
                      : const Color(0x1A000000),
                  backgroundColor: Colors.transparent,
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : (isTablet ? 32 : 64),
                    vertical: 80,
                  ),
                  child: isMobile
                      ? _buildMobileLayout(isLightMode)
                      : _buildDesktopLayout(isLightMode, isTablet),
                ),
              ),

              // Scroll Indicator
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: _buildScrollIndicator(isLightMode),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(bool isLightMode, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Text content
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextContent(isLightMode, isTablet),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 64),

        // Right side - Profile image
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: AnimatedProfileImage(size: isTablet ? 300 : 400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isLightMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedProfileImage(size: 250),
        ),
        const SizedBox(height: 40),
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildTextContent(isLightMode, false, isMobile: true),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(
    bool isLightMode,
    bool isTablet, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Hi there, I'm",
          style: TextStyle(
            fontSize: isMobile ? 28 : (isTablet ? 36 : 48),
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Gradient animated text
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF14B8A6)],
          ).createShader(bounds),
          child: Text(
            'Kelechi',
            style: TextStyle(
              fontSize: isMobile ? 48 : (isTablet ? 64 : 80),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: isMobile ? double.infinity : (isTablet ? 400 : 500),
          child: Text(
            'A passionate front-end developer specializing in web and blockchain technologies, focused on building beautiful, functional, and secure applications.',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              height: 1.6,
              color: isLightMode ? Colors.grey[300] : Colors.grey[700],
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isMobile = sizingInfo.isMobile;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _AnimatedButton(
              label: 'View My Work',
              isPrimary: true,
              onPressed: () {
                // Scroll to projects
              },
            ),
            _AnimatedButton(
              label: 'Contact Me',
              isPrimary: false,
              onPressed: () {
                // Scroll to contact
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildScrollIndicator(bool isLightMode) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Text(
            'Scroll Down',
            style: TextStyle(
              fontSize: 12,
              color: isLightMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 24,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: isLightMode ? Colors.grey[400]! : Colors.grey[600]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1500),
                tween: Tween<double>(begin: 8, end: 24),
                onEnd: () {
                  setState(() {});
                },
                builder: (context, double value, child) {
                  return Container(
                    margin: EdgeInsets.only(top: value - 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isLightMode ? Colors.grey[400] : Colors.grey[600],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _AnimatedButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Provider.of<ThemeProvider>(context).isLightMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (isLightMode ? Colors.white : Colors.black)
                : Colors.transparent,
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: isLightMode ? Colors.white : Colors.black,
                    width: 2,
                  ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovered && !_isPressed
                ? [
                    BoxShadow(
                      color: widget.isPrimary
                          ? (isLightMode
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3))
                          : Colors.transparent,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          transform: Matrix4.identity()
            ..translate(0.0, _isPressed ? 2.0 : (_isHovered ? -4.0 : 0.0)),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.isPrimary
                  ? (isLightMode ? Colors.black : Colors.white)
                  : (isLightMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
