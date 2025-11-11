import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:about_me/theme/theme_provider.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
        return;
      }
    } else if (_currentStep == 1) {
      if (_messageController.text.isEmpty) {
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitForm() async {
    setState(() => _isSubmitting = true);

    // Simulate submission
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _isSubmitted = false;
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    });
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
          color: isLightMode ? Colors.grey[900] : Colors.grey[50],
          child: Column(
            children: [
              _buildHeader(isLightMode),
              const SizedBox(height: 64),
              if (isMobile)
                _buildMobileLayout(isLightMode)
              else
                _buildDesktopLayout(isLightMode, isTablet),
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
          'Get In Touch',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Interested in working together on a web or blockchain project? Let\'s discuss how we can collaborate!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isLightMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isLightMode, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildContactForm(isLightMode)),
        const SizedBox(width: 64),
        Expanded(child: _buildContactInfo(isLightMode)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isLightMode) {
    return Column(
      children: [
        _buildContactForm(isLightMode),
        const SizedBox(height: 48),
        _buildContactInfo(isLightMode),
      ],
    );
  }

  Widget _buildContactForm(bool isLightMode) {
    if (_isSubmitted) {
      return _buildSuccessMessage(isLightMode);
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(isLightMode),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStepContent(isLightMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isLightMode) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(3, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? const Color(0xFF3B82F6)
                        : (isLightMode ? Colors.grey[700] : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Step ${_currentStep + 1} of 3',
          style: TextStyle(
            fontSize: 14,
            color: isLightMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(bool isLightMode) {
    switch (_currentStep) {
      case 0:
        return _buildStep1(isLightMode);
      case 1:
        return _buildStep2(isLightMode);
      case 2:
        return _buildStep3(isLightMode);
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1(bool isLightMode) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Enter your name',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isLightMode ? Colors.grey[900] : Colors.grey[50],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isLightMode ? Colors.grey[900] : Colors.grey[50],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(bool isLightMode) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _messageController,
          decoration: InputDecoration(
            labelText: 'Message',
            hintText: 'Describe your project or collaboration idea',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isLightMode ? Colors.grey[900] : Colors.grey[50],
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3(bool isLightMode) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm & Submit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLightMode ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: isLightMode
                                ? Colors.grey[500]
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _nameController.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isLightMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 12,
                            color: isLightMode
                                ? Colors.grey[500]
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _emailController.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isLightMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Message',
                style: TextStyle(
                  fontSize: 12,
                  color: isLightMode ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _messageController.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isLightMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: isLightMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 18),
                          SizedBox(width: 8),
                          Text('Send Message'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessMessage(bool isLightMode) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Message Sent!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isLightMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Thank you for reaching out. I\'ll get back to you as soon as possible.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isLightMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _reset,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text('Send Another Message'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(bool isLightMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSection('Contact Information', isLightMode, [
          _buildInfoItem(
            Icons.email,
            'Email',
            'nwankwoala3@gmail.com',
            'mailto:nwankwoala3@gmail.com',
            isLightMode,
          ),
        ]),
        const SizedBox(height: 32),
        _buildInfoSection('Areas of Expertise', isLightMode, [
          _buildExpertiseCard(
            'Web Development',
            'Front-end development with modern frameworks',
            isLightMode,
          ),
          _buildExpertiseCard(
            'Blockchain',
            'DApp development and smart contracts',
            isLightMode,
          ),
          _buildExpertiseCard(
            'UI/UX Design',
            'Responsive interfaces with modern patterns',
            isLightMode,
          ),
          _buildExpertiseCard(
            'DevOps',
            'AWS deployment and CI/CD pipelines',
            isLightMode,
          ),
        ]),
        const SizedBox(height: 32),
        _buildInfoSection('Connect With Me', isLightMode, [
          _buildSocialLinks(isLightMode),
        ]),
      ],
    );
  }

  Widget _buildInfoSection(
    String title,
    bool isLightMode,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isLightMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    String url,
    bool isLightMode,
  ) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLightMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isLightMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF3B82F6)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isLightMode ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertiseCard(
    String title,
    String description,
    bool isLightMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLightMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isLightMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isLightMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(bool isLightMode) {
    final socials = [
      {'icon': '👨‍💻', 'label': 'GitHub', 'url': 'https://github.com/nuel232'},
      {
        'icon': '💼',
        'label': 'LinkedIn',
        'url': 'https://www.linkedin.com/in/kelechi-nwankwoala-29b297285',
      },
      {
        'icon': '🐦',
        'label': 'Twitter',
        'url': 'https://twitter.com/_kelechixx_?s=21',
      },
      {
        'icon': '📷',
        'label': 'Instagram',
        'url': 'https://instagram.com/dtw.nuell',
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: socials.map((social) {
        return InkWell(
          onTap: () async {
            final uri = Uri.parse(social['url']!);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLightMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLightMode ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isLightMode ? Colors.grey[700] : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      social['icon']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  social['label']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isLightMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
