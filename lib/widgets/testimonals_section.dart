import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:about_me/theme/theme_provider.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final List<Testimonial> _testimonials = [
    Testimonial(
      name: 'John Doe',
      role: 'Senior Developer',
      company: 'Tech Corp',
      content:
          'Kelechi is an exceptional developer who consistently delivers high-quality work. His attention to detail and problem-solving skills are outstanding.',
    ),
    Testimonial(
      name: 'Jane Smith',
      role: 'Project Manager',
      company: 'Innovate Inc',
      content:
          'Working with Kelechi was a pleasure. He\'s not only technically skilled but also great at communication and collaboration.',
    ),
    Testimonial(
      name: 'Mike Johnson',
      role: 'CTO',
      company: 'StartupX',
      content:
          'Kelechi\'s expertise in front-end development helped us build a robust and scalable application. His contributions were invaluable.',
    ),
  ];

  bool _showAddDialog = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addTestimonial() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _testimonials.add(
          Testimonial(
            name: _nameController.text,
            role: _roleController.text,
            company: _companyController.text,
            content: _contentController.text,
          ),
        );
        _showAddDialog = false;
        _nameController.clear();
        _roleController.clear();
        _companyController.clear();
        _contentController.clear();
      });
    }
  }

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
          color: isDarkMode ? Colors.black : Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(isDarkMode),
                  const SizedBox(height: 64),
                  AnimationLimiter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: _testimonials.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: isMobile ? 1 : (isTablet ? 2 : 3),
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: TestimonialCard(
                                testimonial: _testimonials[index],
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Floating Add Button
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () => setState(() => _showAddDialog = true),
                  backgroundColor: const Color(0xFF3B82F6),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),

              // Add Dialog
              if (_showAddDialog) _buildAddDialog(isDarkMode),
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
          'What People Say',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Hear from colleagues, clients, and mentors about their experience working with me',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAddDialog(bool isDarkMode) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showAddDialog = false),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 500,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Your Testimonial',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _showAddDialog = false),
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Your Name',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                              ),
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _roleController,
                              decoration: InputDecoration(
                                labelText: 'Your Role',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                              ),
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _companyController,
                        decoration: InputDecoration(
                          labelText: 'Company/Organization',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[100],
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: 'Your Testimonial',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[100],
                        ),
                        maxLines: 3,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addTestimonial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Submit Testimonial'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TestimonialCard extends StatefulWidget {
  final Testimonial testimonial;
  final bool isDarkMode;

  const TestimonialCard({
    super.key,
    required this.testimonial,
    required this.isDarkMode,
  });

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? Colors.grey[900]!.withOpacity(0.5)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
                    child: Icon(Icons.person, color: const Color(0xFF3B82F6)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.testimonial.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          '${widget.testimonial.role} at ${widget.testimonial.company}',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isDarkMode
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
              Text(
                widget.testimonial.content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: widget.isDarkMode
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Testimonial {
  final String name;
  final String role;
  final String company;
  final String content;

  Testimonial({
    required this.name,
    required this.role,
    required this.company,
    required this.content,
  });
}
