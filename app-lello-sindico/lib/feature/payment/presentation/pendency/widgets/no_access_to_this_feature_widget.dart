import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class NoAccessToThisFeatureWidget extends StatefulWidget {
  const NoAccessToThisFeatureWidget({super.key});

  @override
  State<NoAccessToThisFeatureWidget> createState() =>
      _NoAccessToThisFeatureWidgetState();
}

class _NoAccessToThisFeatureWidgetState
    extends State<NoAccessToThisFeatureWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/ic_no_access.svg",
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    "Ops! Parece que você não tem acesso a essa função.",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: LelloTheme.palleteOf(theme).grey()),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                      "Para acessar certas funções do app para Síndicos, é necessário ter autorização.",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitleBold(theme)),
                ],
              ),
            ),
          ],
        ));
  }
}
