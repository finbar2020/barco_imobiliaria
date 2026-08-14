import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CameraInstructions extends StatelessWidget {
  final Color colorOverlay;
  final String title;
  final Icon? arrowIcon;

  const CameraInstructions({
    super.key,
    required this.colorOverlay,
    required this.title,
    this.arrowIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (title.isEmpty) {
      return const SizedBox();
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width * 0.95,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            if (arrowIcon != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: arrowIcon!,
              ),
            SizedBox(height: Dimens.spacingXSmall),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: colorOverlay,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: colorOverlay.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: LelloTextStyles.title(theme)!,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
