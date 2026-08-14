import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class BellaNotAvailableWidget extends StatelessWidget {
  final Function() onReturnToMainPage;

  const BellaNotAvailableWidget({
    super.key,
    required this.onReturnToMainPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iaName = FlavorConfig.config.iaName;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: SvgPicture.asset(
              "assets/ic_bella_not_available_error.svg",
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getStringWithParams(context, 'bella_not_available_title', [iaName]),
            style: theme.textTheme.headlineLarge
                ?.copyWith(color: theme.primaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            "Tente novamente mais tarde",
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.spacingMedium),
          PrimaryButton(
            onPressed: onReturnToMainPage,
            text: "Voltar para o início",
            buttonColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }
}
