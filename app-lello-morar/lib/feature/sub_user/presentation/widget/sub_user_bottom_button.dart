import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SubUserBottomButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const SubUserBottomButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PrimaryButton(
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: LelloTheme.palleteOf(theme).customColor(),
                      width: 2),
                ),
                height: Dimens.spacingMedium,
                width: Dimens.spacingMedium,
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 16.0,
                    color: LelloTheme.palleteOf(theme).customColor(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Dimens.spacingSmall,
            ),
            Text(
              title,
              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).customColor(),
              ),
            ),
          ],
        ),
        buttonColor: LelloTheme.palleteOf(theme).textAccent(),
      ),
    );
  }
}
