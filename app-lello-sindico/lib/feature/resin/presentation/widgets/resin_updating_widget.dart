import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ResinUpdatingWidget extends StatelessWidget {
  const ResinUpdatingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: Dimens.spacingSmall,
            width: Dimens.spacingSmall,
            child: const CircularProgressIndicator()),
        SizedBox(width: Dimens.spacing),
        Text(getString(context, "resin_updating")),
      ],
    );
  }
}
