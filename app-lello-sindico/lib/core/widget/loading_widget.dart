import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator(color: theme.primaryColor)),
        SizedBox(height: Dimens.spacing),
        Text(getString(context, "please_wait"),
            style: LelloTextStyles.subtitleBold(theme)),
        if (message?.isNotEmpty == true)
          Text(message!, style: LelloTextStyles.body(theme))
      ],
    );
  }
}
