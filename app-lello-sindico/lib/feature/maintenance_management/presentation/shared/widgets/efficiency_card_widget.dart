import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';

class EfficiencyCardWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const EfficiencyCardWidget({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: palette.background(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: LelloTextStyles.subtitleBold(theme),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
