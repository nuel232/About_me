import 'package:about_me/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _skillCategories = [
    'Frontend',
    'Backend',
    'Blockchain',
    'DevOps & Tools',
  ];

  final Map<String, List<SkillData>> _skills = {
    'Frontend': [
      SkillData('React.js', 0.63),
      SkillData('JavaScript/TypeScript', 0.63),
      SkillData('HTML/CSS', 0.67),
      SkillData('Tailwind CSS', 0.60),
      SkillData('Responsive Design', 0.63),
      SkillData('Flutter', 0.30),
    ],
    'Backend': [
      SkillData('Node.js/Express', 0.60),
      SkillData('Django', 0.42),
      SkillData('MongoDB', 0.56),
      SkillData('MySQL', 0.53),
      SkillData('RESTful APIs', 0.60),
    ],
    'Blockchain': [
      SkillData('Solidity', 0.56),
      SkillData('Ethereum', 0.53),
      SkillData('Smart Contracts', 0.56),
      SkillData('Web3.js', 0.53),
      SkillData('DApp Development', 0.53),
    ],
    'DevOps & Tools': [
      SkillData('Git/GitHub', 0.63),
      SkillData('AWS', 0.49),
      SkillData('Docker', 0.46),
      SkillData('CI/CD', 0.49),
      SkillData('Testing', 0.53),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _skillCategories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Provider.of<ThemeProvider>(context).isLightMode;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isMobile = sizingInfo.isMobile;
        final isTablet = sizingInfo.isTablet;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : (isTablet ? 32 : 64),
            vertical: 80,
          ),
          color: isLightMode ? Colors.black : Colors.white,
          child: Column(
            children: [
              _buildHeader(isLightMode),
              const SizedBox(height: 64),
              _buildAboutContent(isLightMode, isMobile, isTablet),
              const SizedBox(height: 80),
              _buildEducationSection(isLightMode, isMobile),
              const SizedBox(height: 80),
              _buildExperienceSection(isLightMode, isMobile),
              const SizedBox(height: 80),
              _buildSkillsSection(isLightMode, isMobile),
              const SizedBox(height: 80),
              _buildServicesSection(isLightMode, isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isLightMode) {
    return Column(
      children: [
        Text(
          'About Me',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A passionate developer with expertise in both web and blockchain technologies',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isLightMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutContent(bool isLightMode, bool isMobile, bool isTablet) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: isMobile
              ? Column(
                  children: [
                    _buildProfileImage(isLightMode),
                    const SizedBox(height: 32),
                    _buildAboutText(isLightMode),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildProfileImage(isLightMode)),
                    const SizedBox(width: 48),
                    Expanded(child: _buildAboutText(isLightMode)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(bool isLightMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            'assets/profile.jpg', // your image path
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildAboutText(bool isLightMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLightMode
            ? Colors.grey[900]!.withOpacity(0.5)
            : Colors.grey[100]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kelechi',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isLightMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'I am a passionate and skilled front-end developer with a strong focus on blockchain technologies. My journey in technology started with a deep interest in how digital solutions can solve real-world problems.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isLightMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Currently pursuing my degree in Computer Science at Veritas University, I balance my academic work with practical experience in developing web applications and blockchain solutions.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isLightMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse('/CV.pdf');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            icon: const Icon(Icons.download),
            label: const Text('Download CV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildContactInfo(isLightMode, Icons.email, 'nwankwoala3@Gmail.com'),
          const SizedBox(height: 12),
          _buildContactInfo(isLightMode, Icons.phone, '+234 915 641 4321'),
          const SizedBox(height: 12),
          _buildContactInfo(isLightMode, Icons.location_on, 'Abuja, Nigeria'),
        ],
      ),
    );
  }

  Widget _buildContactInfo(bool isLightMode, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF3B82F6)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isLightMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationSection(bool isLightMode, bool isMobile) {
    final educationData = [
      {
        'degree': 'B.Sc. Computer Science',
        'institution': 'Veritas University',
        'location': 'Abuja',
        'period': 'Oct 2021 – Jun 2025',
      },
      {
        'degree': 'IoT Fundamentals: Connecting Things',
        'institution': 'CISCO Networking Academy',
        'location': '',
        'period': 'Oct 2023 – Jun 2024',
      },
      {
        'degree': 'Advanced JavaScript',
        'institution': 'Codecademy',
        'location': '',
        'period': 'Aug 2023 – Nov 2023',
      },
    ];

    return Column(
      children: [
        Text(
          'Education',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: educationData
                  .map((edu) => _buildEducationCard(edu, isLightMode))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard(Map<String, String> edu, bool isLightMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLightMode
            ? Colors.grey[900]!.withOpacity(0.5)
            : Colors.grey[100]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Color(0xFF3B82F6), size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu['degree']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isLightMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  edu['institution']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${edu['location']!.isNotEmpty ? '${edu['location']} • ' : ''}${edu['period']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isLightMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(bool isLightMode, bool isMobile) {
    final experienceData = [
      {
        'position': 'Back-end Developer',
        'company': 'HNG Tech',
        'location': 'Abuja',
        'period': 'Jun 2024 – Aug 2024',
        'responsibilities': [
          'Formed backend committees to assign tasks and manage features',
          'Managed task assignments and reallocations to enhance productivity',
          'Completed at least one working feature per week',
        ],
      },
      {
        'position': 'Web Developer Intern',
        'company': 'Olog Incorporated',
        'location': 'Abuja',
        'period': 'Aug 2023 – Oct 2023',
        'responsibilities': [
          'Enhanced HTML and CSS skills during internship',
          'Designed and styled user interfaces for web projects',
          'Implemented dynamic functionality using JavaScript',
        ],
      },
    ];

    return Column(
      children: [
        Text(
          'Experience',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: -50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: experienceData
                  .map((exp) => _buildExperienceCard(exp, isLightMode))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> exp, bool isLightMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLightMode
            ? Colors.grey[900]!.withOpacity(0.5)
            : Colors.grey[100]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work,
                  color: Color(0xFF3B82F6),
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp['position']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isLightMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      exp['company']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${exp['location']} • ${exp['period']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isLightMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(exp['responsibilities'] as List<String>).map(
            (resp) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Color(0xFF3B82F6))),
                  Expanded(
                    child: Text(
                      resp,
                      style: TextStyle(
                        fontSize: 14,
                        color: isLightMode
                            ? Colors.grey[300]
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isLightMode, bool isMobile) {
    return Column(
      children: [
        Text(
          'Skills',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isLightMode
                ? Colors.grey[900]!.withOpacity(0.5)
                : Colors.grey[100]!.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: isMobile,
                labelColor: const Color(0xFF3B82F6),
                unselectedLabelColor: isLightMode
                    ? Colors.grey[400]
                    : Colors.grey[600],
                indicatorColor: const Color(0xFF3B82F6),
                tabs: _skillCategories
                    .map((category) => Tab(text: category))
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: _skillCategories.map((category) {
                    return AnimationLimiter(
                      child: ListView.builder(
                        itemCount: _skills[category]!.length,
                        itemBuilder: (context, index) {
                          final skill = _skills[category]![index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildSkillBar(skill, isLightMode),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillBar(SkillData skill, bool isLightMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLightMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '${(skill.level * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: skill.level),
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: isLightMode
                      ? Colors.grey[700]
                      : Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF3B82F6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(bool isLightMode, bool isMobile) {
    final services = [
      {
        'icon': '🌐',
        'title': 'Web Development',
        'description': 'Front-end web applications with modern frameworks',
      },
      {
        'icon': '⛓️',
        'title': 'Blockchain Solutions',
        'description': 'Smart contracts, DApps, and blockchain integrations',
      },
      {
        'icon': '🎨',
        'title': 'UI/UX Design',
        'description': 'User-friendly interfaces with focus on accessibility',
      },
      {
        'icon': '📱',
        'title': 'Flutter App Development',
        'description': 'Cross-platform mobile applications',
      },
    ];

    return Column(
      children: [
        Text(
          'Services',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        AnimationLimiter(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.1,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: isMobile ? 1 : 4,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildServiceCard(services[index], isLightMode),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, String> service, bool isLightMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLightMode
            ? Colors.grey[900]!.withOpacity(0.5)
            : Colors.grey[100]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(service['icon']!, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            service['title']!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLightMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            service['description']!,
            style: TextStyle(
              fontSize: 14,
              color: isLightMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SkillData {
  final String name;
  final double level;

  SkillData(this.name, this.level);
}
