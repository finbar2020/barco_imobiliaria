import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_app_bar.dart';

class FeatureMovedFullscreenDialog extends StatelessWidget {
  const FeatureMovedFullscreenDialog({
    required this.appBarTitle,
    required this.message,
    required this.route,
    Key? key,
  }) : super(key: key);

  final String appBarTitle;
  final String message;
  final String route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/full_screen_dialog_image.svg'),
            SizedBox(
              height: Dimens.spacingMedium,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  getString(context, 'function_moved'),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme)?.copyWith(
                    fontSize: 32,
                  ),
                ),
                SizedBox(
                  height: Dimens.spacingMedium,
                ),
                Text(
                  getString(context, message),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: Dimens.spacingMedium,
                ),
                Text(
                  getString(context, 'click_take_me_there'),
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, route);
            },
            text: getString(context, 'take_me_there'),
          ),
        ),
      ),
    );
  }
}