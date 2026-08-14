import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: CircularProgressIndicator()),
        SizedBox(height: Dimens.spacing),
        if (message?.isNotEmpty == true)
          Container(
            padding: EdgeInsets.only(bottom: Dimens.spacing),
            child: Text(
              message!,
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
          ),
        Text(
          getString(context, "please_wait", defaultText: "Por favor, aguarde"),
          style: LelloTextStyles.body(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
        ),
      ],
    );
  }
}
