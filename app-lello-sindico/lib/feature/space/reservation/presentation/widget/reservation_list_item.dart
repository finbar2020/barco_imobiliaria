import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

class ReservationListItem extends StatelessWidget {
  final VoidCallback? onRefreshRequested;
  final Reservation? reservation;
  final ReservationItemHeader headerType;
  final monthFormat = DateFormat.yMMMM();
  final dateFormat = DateFormat.yMd();
  final dayFormat = DateFormat.d();
  final timeFormat = DateFormat.jm();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");

  ReservationListItem(
      {Key? key,
      this.reservation,
      this.onRefreshRequested,
      this.headerType = ReservationItemHeader.SHOW_DAY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (headerType) {
      case ReservationItemHeader.SHOW_DAY:
        return _buildDayHeader(context, theme);
      case ReservationItemHeader.SHOW_TYPE:
        return _buildTypeHeader(context, theme);
    }
  }

  Widget _buildTypeHeader(BuildContext context, ThemeData theme) {
    return CustomExpansionTile(
      showDivider: false,
      leading: Container(
        width: Dimens.spacingMedium,
        height: Dimens.spacingMedium,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: _getColor(context, theme)),
      ),
      title: Text(_getTitle(context), style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(reservation?.space?.name ?? "-",
          style: LelloTextStyles.subBody(theme)),
      children: [_buildChildren(context, theme)],
    );
  }

  Widget _buildDayHeader(BuildContext context, ThemeData theme) {
    return CustomExpansionTile(
      showDivider: false,
      leading: Container(
        padding: EdgeInsets.all(Dimens.spacing),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: _getColor(context, theme)),
        child: Text(dayFormat.format(reservation!.from!).padLeft(2, '0'),
            style: LelloTextStyles.titleSmall(LelloTheme.dark)),
      ),
      title: Text(monthFormat.format(reservation!.from!),
          style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(_getTitle(context), style: LelloTextStyles.body(theme)),
      children: [_buildChildren(context, theme)],
    );
  }

  String _getTitle(BuildContext context) {
    switch (reservation!.type) {
      case ReservationType.maintenance:
        return getString(context, "space_reservation_maintenance");
      case ReservationType.raffle:
        return getString(context, "space_reservation_raffle");
      case ReservationType.reservation:
        return getString(context, "space_reservation_reservation");
      default:
        return "";
    }
  }

  Color _getColor(BuildContext context, ThemeData theme) {
    switch (reservation!.type!) {
      case ReservationType.maintenance:
        return LelloTheme.palleteOf(theme).warning();
      case ReservationType.raffle:
        return LelloTheme.palleteOf(theme).raffle();
      case ReservationType.reservation:
        return theme.primaryColor;
    }
  }

  Widget _buildChildren(BuildContext context, ThemeData theme) {
    switch (reservation!.type!) {
      case ReservationType.maintenance:
        return _buildMaintenance(context, theme);
      case ReservationType.raffle:
        return _buildRaffle(context, theme);
      case ReservationType.reservation:
        return _buildReservation(context, theme);
    }
  }

  Widget _buildMaintenance(BuildContext context, ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        title: Text(getString(context, "space_reservation_area"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(reservation?.space?.name ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_date"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.from != null
                ? dateFormat.format(reservation!.from!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_time"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.from != null
                ? timeFormat.format(reservation!.from!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      _buildCancelButton(context, theme)
    ]);
  }

  Widget _buildRaffle(BuildContext context, ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        title: Text(getString(context, "space_reservation_area"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(reservation?.space?.name ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_date"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.from != null
                ? dateFormat.format(reservation!.from!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      Padding(
        padding: EdgeInsets.all(Dimens.spacing),
        child: PrimaryButton(
          text: getString(context, "space_reservation_do_raffle"),
          onPressed: () async {
            await Navigator.of(context).pushNamed(
                ApplicationRoute.spaceReservationDrawRaffle,
                arguments: reservation);
            onRefreshRequested?.call();
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(Dimens.spacing).copyWith(top: 0),
        child: _buildCancelButton(context, theme, hidePadding: true),
      )
    ]);
  }

  Widget _buildReservation(BuildContext context, ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        title: Text(getString(context, "space_reservation_unit"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(reservation?.unit?.title ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_area"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(reservation?.space?.name ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_date"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.from != null
                ? dateFormat.format(reservation!.from!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_time"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.from != null
                ? timeFormat.format(reservation!.from!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_price"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(currencyFormat.format(reservation?.price ?? 0),
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_expiration"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.expiration != null
                ? timeFormat.format(reservation!.expiration!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_receipt"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(reservation?.receipt ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_cancellation_limit"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(
            reservation?.cancellationLimit != null
                ? timeFormat.format(reservation!.cancellationLimit!)
                : "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      ListTile(
        title: Text(getString(context, "space_reservation_status"),
            style: LelloTextStyles.bodyBold(theme)),
        subtitle: Text(reservation?.status ?? "-",
            style: LelloTextStyles.subBody(theme)),
      ),
      _buildCancelButton(context, theme)
    ]);
  }

  Widget _buildCancelButton(BuildContext context, ThemeData theme,
      {bool hidePadding = false}) {
    return Padding(
      padding: EdgeInsets.all(hidePadding ? 0 : Dimens.spacing),
      child: SecondaryButton(
        text: getString(context, "cancel"),
        onPressed: () async {
          await Navigator.of(context).pushNamed(
              ApplicationRoute.spaceReservationConfirmCancel,
              arguments: reservation);
          if (onRefreshRequested != null) onRefreshRequested!();
        },
      ),
    );
  }
}

enum ReservationItemHeader { SHOW_DAY, SHOW_TYPE }
