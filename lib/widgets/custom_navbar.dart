import 'package:about_me/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomNavbar extends StatefulWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onProjectsPressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;
  final ScrollController scrollController;

  const CustomNavbar({
    Key? key,
    required this.onHomePressed,
    required this.onProjectsPressed,
    required this.onAboutPressed,
    required this.onContactPressed,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar>
    with SingleTickerProviderStateMixin {
  bool _isScrolled = false;
  bool _isMobileMenuOpen = false;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOut,
    );
  }

  void _onScroll() {
    if (widget.scrollController.offset > 10 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (widget.scrollController.offset <= 10 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _toggleMobileMenu() {
    setState(() {
      _isMobileMenuOpen = !_isMobileMenuOpen;
      if (_isMobileMenuOpen) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  void _handleNavigation(VoidCallback callback) {
    if (_isMobileMenuOpen) {
      _toggleMobileMenu();
    }
    callback();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isMobile = sizingInfo.isMobile;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Navbar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: _isScrolled
                    ? (isDarkMode
                          ? Colors.grey[900]!.withOpacity(0.95)
                          : Colors.white.withOpacity(0.95))
                    : Colors.transparent,
                boxShadow: _isScrolled
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.onHomePressed,
                        child: Text(
                          'Kelechi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    if (!isMobile) ...[
                      // Desktop Menu
                      Row(
                        children: [
                          _NavItem(label: 'Home', onTap: widget.onHomePressed),
                          const SizedBox(width: 32),
                          _NavItem(
                            label: 'Projects',
                            onTap: widget.onProjectsPressed,
                          ),
                          const SizedBox(width: 32),
                          _NavItem(
                            label: 'About',
                            onTap: widget.onAboutPressed,
                          ),
                          const SizedBox(width: 32),
                          _NavItem(
                            label: 'Contact',
                            onTap: widget.onContactPressed,
                          ),
                        ],
                      ),

                      // Social Links & Theme Toggle
                      Row(
                        children: [
                          _SocialIcon(
                            icon: FontAwesomeIcons.github,
                            url: 'https://github.com/nuel232',
                          ),
                          const SizedBox(width: 16),
                          _SocialIcon(
                            icon: FontAwesomeIcons.linkedin,
                            url:
                                'https://www.linkedin.com/in/kelechi-nwankwoala-29b297285',
                          ),
                          const SizedBox(width: 16),
                          _SocialIcon(
                            icon: FontAwesomeIcons.twitter,
                            url: 'https://twitter.com/_kelechixx_?s=21',
                          ),
                          const SizedBox(width: 16),
                          _ThemeToggleButton(),
                        ],
                      ),
                    ] else ...[
                      // Mobile: Theme Toggle + Menu Button
                      Row(
                        children: [
                          _ThemeToggleButton(),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: _menuAnimation,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: _toggleMobileMenu,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Mobile Menu
            if (isMobile)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isMobileMenuOpen
                    ? _buildMobileMenu(isDarkMode)
                    : const SizedBox.shrink(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMobileMenu(bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _MobileNavItem(
            label: 'Home',
            onTap: () => _handleNavigation(widget.onHomePressed),
          ),
          _MobileNavItem(
            label: 'Projects',
            onTap: () => _handleNavigation(widget.onProjectsPressed),
          ),
          _MobileNavItem(
            label: 'About',
            onTap: () => _handleNavigation(widget.onAboutPressed),
          ),
          _MobileNavItem(
            label: 'Contact',
            onTap: () => _handleNavigation(widget.onContactPressed),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialIcon(
                  icon: FontAwesomeIcons.github,
                  url: 'https://github.com/nuel232',
                ),
                const SizedBox(width: 20),
                _SocialIcon(
                  icon: FontAwesomeIcons.linkedin,
                  url:
                      'https://www.linkedin.com/in/kelechi-nwankwoala-29b297285',
                ),
                const SizedBox(width: 20),
                _SocialIcon(
                  icon: FontAwesomeIcons.twitter,
                  url: 'https://twitter.com/_kelechixx_?s=21',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 16,
            color: _isHovered
                ? const Color(0xFF3B82F6)
                : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MobileNavItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: themeProvider.toggleTheme,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              key: ValueKey(isDarkMode),
              color: isDarkMode ? Colors.yellow[700] : Colors.grey[700],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered
                ? const Color(0xFF3B82F6)
                : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}
