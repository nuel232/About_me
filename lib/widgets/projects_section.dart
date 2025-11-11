import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:about_me/theme/theme_provider.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isMobile = sizingInfo.isMobile;
        final isTablet = sizingInfo.isTablet;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : (isTablet ? 32 : 64),
            vertical: 80,
          ),
          color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
          child: Column(
            children: [
              _buildHeader(isDarkMode),
              const SizedBox(height: 64),
              if (isMobile)
                _buildMobileGrid(isDarkMode)
              else if (isTablet)
                _buildTabletGrid(isDarkMode)
              else
                _buildDesktopGrid(isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      children: [
        Text(
          'Featured Projects',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A selection of my recent work, showcasing web development, blockchain and front-end skills.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid(bool isDarkMode) {
    return AnimationLimiter(
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.8,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            ProjectCard(
              title: 'Decentralized Voting System',
              description:
                  'A secure and transparent voting platform built on Ethereum blockchain that enables tamper-proof voting records, remote voting, and maintains voter anonymity.',
              icon: Icons.how_to_vote_rounded,
              gridHeight: 2,
              isDarkMode: isDarkMode,
            ),
            ProjectCard(
              title: 'Blockchain Certificate Authentication',
              description:
                  'A decentralized application for storing and verifying academic certificates on the Ethereum blockchain with smart contracts and verification functionality.',
              icon: Icons.verified_rounded,
              gridHeight: 1,
              isDarkMode: isDarkMode,
            ),
            ProjectCard(
              title: 'Gemini AI Integration',
              description:
                  'A web application that integrates Google\'s Gemini AI model to provide conversational AI capabilities with a React-based UI.',
              icon: Icons.psychology_rounded,
              gridHeight: 1,
              isDarkMode: isDarkMode,
            ),
            ProjectCard(
              title: 'Student Exeat Permission System',
              description:
                  'A comprehensive MERN stack web application for Veritas University to manage student exeat permissions with a multi-stage approval workflow.',
              icon: Icons.school_rounded,
              gridHeight: 2,
              isDarkMode: isDarkMode,
            ),
            ProjectCard(
              title: 'Django Web Applications',
              description:
                  'Multiple Django web applications including e-commerce platforms, weather applications, and API implementations using Django REST framework.',
              icon: Icons.code_rounded,
              gridHeight: 3,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletGrid(bool isDarkMode) {
    return AnimationLimiter(
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.0,
        children: _buildAllProjects(isDarkMode),
      ),
    );
  }

  Widget _buildMobileGrid(bool isDarkMode) {
    return AnimationLimiter(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: _buildAllProjects(isDarkMode),
        ),
      ),
    );
  }

  List<Widget> _buildAllProjects(bool isDarkMode) {
    return [
      ProjectCard(
        title: 'Decentralized Voting System',
        description:
            'A secure and transparent voting platform built on Ethereum blockchain.',
        icon: Icons.how_to_vote_rounded,
        isDarkMode: isDarkMode,
      ),
      ProjectCard(
        title: 'Blockchain Certificate Authentication',
        description:
            'A decentralized application for storing and verifying academic certificates.',
        icon: Icons.verified_rounded,
        isDarkMode: isDarkMode,
      ),
      ProjectCard(
        title: 'Student Exeat Permission System',
        description:
            'A comprehensive MERN stack web application for Veritas University.',
        icon: Icons.school_rounded,
        isDarkMode: isDarkMode,
      ),
      ProjectCard(
        title: 'Gemini AI Integration',
        description:
            'A web application that integrates Google\'s Gemini AI model.',
        icon: Icons.psychology_rounded,
        isDarkMode: isDarkMode,
      ),
      ProjectCard(
        title: 'Django Web Applications',
        description:
            'Multiple Django web applications including e-commerce platforms.',
        icon: Icons.code_rounded,
        isDarkMode: isDarkMode,
      ),
    ];
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final int gridHeight;
  final bool isDarkMode;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.gridHeight = 1,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _scaleController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _scaleController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.05,
                  child: Icon(
                    widget.icon,
                    size: 120,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: widget.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          Text(
                            'View Project',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(left: _isHovered ? 8 : 4),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
