import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_header_widget.dart';

class BellaInfoBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final iaName = FlavorConfig.config.iaName;
    final listTextStyle = LelloTextStyles.body(theme)!.copyWith(
      // Keep typography consistent and use fallback only if a glyph is missing.
      fontFamily: 'Roboto',
      fontFamilyFallback: const ['sans-serif'],
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.spacingLarge,
        vertical: Dimens.spacingLarge,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: BellaHeaderWidget(width: 250, height: 200),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
                getStringWithParams(context, 'bella_info_title', [iaName]),
                textAlign: TextAlign.center,
                style: LelloTextStyles.titleBold(theme)),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Center(
            child: Text(
              "Com ela, você pode:",
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              List<String> items = [
                "Consultar boletos e 2ª via;",
                "Acessar documentos do condomínio",
                "Esclarecer regras do condomínio",
                "Tirar d\u00FAvidas frequentes",
              ];
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimens.spacingXSmall,
                    horizontal: Dimens.spacingMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: Dimens.spacingXSmall),
                    Expanded(
                      child: Text(
                        items[index],
                        style: listTextStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: Dimens.spacing),
          Text(getStringWithParams(context, 'bella_privacy_notice', [iaName]),
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getStringWithParams(
                      context, 'bella_error_warning_title', [iaName]),
                  style: LelloTextStyles.bodyBold(theme)!
                      .copyWith(color: theme.primaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          InvertedPrimaryButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Fechar",
          ),
        ],
      ),
    );
  }
}
