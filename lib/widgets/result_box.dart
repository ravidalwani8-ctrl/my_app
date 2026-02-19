import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ResultBox extends StatelessWidget {
  final String label;
  final String value;
  final bool canCopy;

  const ResultBox({
    super.key,
    required this.label,
    required this.value,
    this.canCopy = true,
  });

  bool get _canCopy {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.toLowerCase().startsWith('error')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: AppTheme.mainGradient, // Matches global theme
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: (_canCopy && canCopy)
                      ? () async {
                          await Clipboard.setData(ClipboardData(text: value));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Result copied"),
                                duration: Duration(milliseconds: 900),
                              ),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text("Copy"),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
