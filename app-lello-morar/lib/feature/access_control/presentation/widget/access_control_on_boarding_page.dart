import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccessControlOnBoardingPage extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subtitle;
  final int currentPage;
  const AccessControlOnBoardingPage({
    Key? key,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            child: Stack(
              children: [
                SvgPicture.asset("assets/access_onboarding_bg.svg"),
                Center(
                  child: SvgPicture.asset(assetPath),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
          child: Column(
            children: [
              SizedBox(height: Dimens.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(theme),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context, title),
                textAlign: TextAlign.center,
                style: LelloTextStyles.title(theme)?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context, subtitle),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicator(ThemeData theme) {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
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
