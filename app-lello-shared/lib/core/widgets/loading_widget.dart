import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator()),
        SizedBox(height: Dimens.spacing),
        Text(
            getString(context, "please_wait",
                defaultText: "Por favor, aguarde"),
            style: LelloTextStyles.body(theme)),
      ],
    );
  }
}
