import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientHeader extends StatelessWidget {
  final String title;
  final bool showBack;

  const GradientHeader({super.key, required this.title, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 45, bottom: 25, left: 16, right: 16),
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          if (!showBack) const SizedBox(width: 48),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
