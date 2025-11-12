import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:about_me/theme/theme_provider.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final currentYear = DateTime.now().year;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Center(
        child: Text(
          '© $currentYear Kelechi. All rights reserved.',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
