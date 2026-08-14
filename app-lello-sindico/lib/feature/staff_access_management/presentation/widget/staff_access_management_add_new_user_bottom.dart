import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class StaffAccessManagementAddNewUserBottom extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  const StaffAccessManagementAddNewUserBottom({
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
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: LelloTheme.palleteOf(theme).textAccent(), width: 2),
              ),
              height: Dimens.spacingMedium,
              width: Dimens.spacingMedium,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 16.0,
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
              decoration: TextDecoration.underline,
              decorationColor: LelloTheme.palleteOf(theme).textAccent(),
            ),
          ),
        ],
      ),
    );
  }
}
