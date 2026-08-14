import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/navigation/application_route.dart';

class ReservationControlMainPage extends StatelessWidget {
  const ReservationControlMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          iconColor: theme.primaryColor,
          title: getString(context, "space_reservation_control"),
          theme: theme,
        ),
        body: _buildList(context, theme),
      ),
    );
  }

  Widget _buildList(BuildContext context, ThemeData theme) {
    return ListView(
      children: [
        _buildListItem(getString(context, "space_reservation_agenda"),
            "assets/ic_reservation_control.svg", theme, onTap: () {
          Navigator.of(context).pushNamed(
              ApplicationRoute.spaceReservationCalendar,
              arguments: true);
        }),
        const Divider(),
        _buildListItem(getString(context, "space_reservation_report"),
            "assets/ic_report.svg", theme, onTap: () {
          Navigator.of(context)
              .pushNamed(ApplicationRoute.spaceReservationReport);
        }),
        const Divider(),
      ],
    );
  }

  Widget _buildListItem(String title, String asset, ThemeData theme,
      {VoidCallback? onTap}) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.only(
              left: Dimens.spacingLarge,
              right: Dimens.spacingLarge,
              top: Dimens.spacingSmall,
              bottom: Dimens.spacingSmall),
          leading: SvgPicture.asset(asset, width: 24),
          title: Text(title, style: LelloTextStyles.bodyBold(theme))),
    );
  }
}
