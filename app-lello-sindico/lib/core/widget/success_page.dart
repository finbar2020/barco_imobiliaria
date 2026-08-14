import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

/// Página de sucesso padrão do app: fundo verde, ícone de check, título,
/// subtítulo opcional e um botão de ação branco.
///
/// Modelada na tela de sucesso de recomendação de prestação de contas
/// (`SendRecommendationSuccessPage`), extraída para reuso entre features.
/// É uma página completa (própria `Scaffold`), então use como destino de rota
/// ou retorne-a como tela inteira (sem `AppBar`).
class SuccessPage extends StatelessWidget {
  /// Título principal (ex.: "Solicitação enviada com sucesso!").
  final String title;

  /// Linha secundária opcional (ex.: nome do condomínio).
  final String? subtitle;

  /// Texto do botão de ação.
  final String buttonText;

  /// Ação do botão (ex.: fechar o fluxo).
  final VoidCallback onPressed;

  /// Asset (SVG) do ícone. Default: check de sucesso padrão do app.
  final String iconAsset;

  const SuccessPage({
    Key? key,
    required this.title,
    required this.buttonText,
    required this.onPressed,
    this.subtitle,
    this.iconAsset = "assets/ic_success.svg",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(iconAsset, width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.headline(theme)!
                      .copyWith(color: Colors.white),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: Dimens.spacingSmall),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white),
                  ),
                ],
                SizedBox(height: Dimens.spacingXLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                    buttonColor: Colors.white,
                    text: buttonText,
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
