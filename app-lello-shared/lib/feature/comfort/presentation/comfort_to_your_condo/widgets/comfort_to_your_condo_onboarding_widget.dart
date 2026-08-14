import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/shared_features.dart';

class ComfortToYourCondoOnboardingWidet extends StatelessWidget {
  final ComfortPartnersController comfortPartnersController;
  final int numPages;
  final bool fromIcon;
  final String assetPath;
  final String title;
  final dynamic subtitle;
  final int currentPage;
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  final String reference;
  final String? unit;
  const ComfortToYourCondoOnboardingWidet({
    Key? key,
    this.fromIcon = false,
    required this.numPages,
    required this.comfortPartnersController,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.currentPage,
    required this.appContainer,
    required this.appOriginEnum,
    required this.reference,
    this.unit,
    required,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            fromIcon
                ? Navigator.pop(context)
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ToYourCondoPage(
                        comfortPartnersController: comfortPartnersController,
                        appContainer: appContainer,
                        appOriginEnum: appOriginEnum,
                        reference: reference,
                        unit: unit,
                      ),
                    ),
                  );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                getString(context, "skip"),
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
        ),
        Center(child: SvgPicture.asset(assetPath)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
          child: Column(
            children: [
              SizedBox(height: Dimens.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(theme),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                title,
                textAlign: TextAlign.start,
                style: LelloTextStyles.title(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              subtitle is String
                  ? Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)
                          ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                    )
                  : subtitle,
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicator(ThemeData theme) {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(i == currentPage
          ? _indicator(theme, true)
          : _indicator(theme, false));
    }
    return list;
  }

  Widget _indicator(ThemeData theme, bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        color: isActive
            ? theme.primaryColor
            : LelloTheme.palleteOf(theme).customColor(),
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        border: Border.all(color: theme.primaryColor),
      ),
    );
  }
}
