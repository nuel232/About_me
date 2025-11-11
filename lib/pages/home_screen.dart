import 'package:about_me/widgets/testimonals_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:about_me/theme/theme_provider.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Provider.of<ThemeProvider>(context).isLightMode;
    // Get the status bar height (includes notch/hole punch)
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero Section
                Container(key: _homeKey, child: const HeroSection()),

                // Projects Section
                Container(key: _projectsKey, child: const ProjectsSection()),

                // About Section
                Container(key: _aboutKey, child: const AboutSection()),

                // Testimonials Section
                const TestimonialsSection(),

                // Contact Section
                Container(key: _contactKey, child: const ContactSection()),

                // Footer
                const Footer(),
              ],
            ),
          ),

          // Navbar overlay - now positioned below status bar
          Positioned(
            top: topPadding, // This pushes the navbar below the status bar
            left: 0,
            right: 0,
            child: CustomNavbar(
              onHomePressed: () => _scrollToSection(_homeKey),
              onProjectsPressed: () => _scrollToSection(_projectsKey),
              onAboutPressed: () => _scrollToSection(_aboutKey),
              onContactPressed: () => _scrollToSection(_contactKey),
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
