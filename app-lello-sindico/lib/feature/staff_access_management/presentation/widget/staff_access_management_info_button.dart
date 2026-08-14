import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class StaffAccessManagementInfoButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  const StaffAccessManagementInfoButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              height: Dimens.spacingMedium,
              width: Dimens.spacingMedium,
              child: Center(
                child: Icon(
                  Icons.info_outline,
                  size: 25.0,
                  color: LelloTheme.palleteOf(theme).textAccent(),
                ),
              ),
            ),
          ),
          SizedBox(
            width: Dimens.spacingSmall,
          ),
          Text(
            title,
            style: LelloTextStyles.subBody(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textAccent(),
            ),
          ),
        ],
      ),
    );
  }
}
