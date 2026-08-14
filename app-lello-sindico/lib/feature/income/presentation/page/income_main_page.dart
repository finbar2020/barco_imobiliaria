import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/navigation/application_route.dart';

class IncomeMainPage extends StatelessWidget {
  const IncomeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, "income_title")),
        body: _buildList(context, theme),
      ),
    );
  }

  Widget _buildList(BuildContext context, ThemeData theme) {
    return ListView(
      children: [
        _buildItem(context, theme, "assets/ic_barcode.svg",
            getString(context, "income_monthly_billets"), () {
          Navigator.of(context).pushNamed(ApplicationRoute.billets);
        }),
        const Divider(),
        _buildItem(context, theme, "assets/ic_chart.svg",
            getString(context, "income_control"), () {
          Navigator.of(context).pushNamed(ApplicationRoute.incomeDashboard);
        }),
        const Divider(),
      ],
    );
  }

  Widget _buildItem(BuildContext context, ThemeData theme, String icon,
      String text, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(
          left: Dimens.spacingLarge,
          right: Dimens.spacingLarge,
          top: Dimens.spacingSmall,
          bottom: Dimens.spacingSmall),
      leading: SvgPicture.asset(icon, width: 24),
      title: Text(text, style: LelloTextStyles.bodyBold(theme)),
    );
  }
}
