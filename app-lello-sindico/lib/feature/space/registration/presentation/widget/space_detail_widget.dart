import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/domain/entity/reservation_payment_method.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:sprintf/sprintf.dart';

class SpaceDetailWidget extends StatefulWidget {
  final Space space;
  final Function(SpaceRegistrationStep) onEditRequested;
  final bool shrinkList;
  final bool showEdit;

  SpaceDetailWidget(
      {Key? key,
      required this.space,
      required this.shrinkList,
      this.showEdit = true,
      required this.onEditRequested})
      : super(key: key);

  @override
  _SpaceDetailWidgetState createState() => _SpaceDetailWidgetState();
}

class _SpaceDetailWidgetState extends State<SpaceDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = widget.space;
    final currencyFormat = new NumberFormat.currency(symbol: "R\$");
    return ListView(
      padding: widget.shrinkList ? EdgeInsets.zero : null,
      shrinkWrap: widget.shrinkList,
      physics: widget.shrinkList ? NeverScrollableScrollPhysics() : null,
      children: <Widget>[
        Divider(),
        _buildHeader(theme, getString(context, "space_registration_data_title"),
            SpaceRegistrationStep.data),
        _buildItem(theme, getString(context, "space_registration_data_type"),
            widget.space.type?.description ?? "-"),
        _buildItem(theme, getString(context, "space_registration_data_name"),
            _value(space.name) ?? ""),
        _buildItem(theme, getString(context, "space_registration_description"),
            _value(space.description!) ?? ""),
        _buildItem(theme, getString(context, "space_registration_capacity"),
            _value(space.capacity?.toString() ?? "0") ?? ""),
        _buildItem(theme, getString(context, "space_registration_shared_space"),
            _value(space.sharedSpace?.name ?? "") ?? ""),
        _buildPreviewImage(theme, widget.space.pendingPicture!),
        Divider(),
        _buildHeader(
            theme,
            getString(context, "space_registration_rules_title"),
            SpaceRegistrationStep.rules),
        _buildItem(
            theme,
            getString(context, "space_registration_block_settlers"),
            _yesOrNoTitle(space.reservationRule.blockedForSettlers!)),
        _buildItem(
            theme,
            getString(context, "space_registration_block_defaulters"),
            _yesOrNoTitle(space.reservationRule.blockedForDefaulters!)),
        _buildItem(theme, getString(context, "space_registration_rule_article"),
            _value(space.reservationRule.blockageArticle) ?? ""),
        Padding(
            padding: EdgeInsets.all(Dimens.spacing).copyWith(bottom: 0),
            child: Text(getString(context, "space_registration_rule_open_hour"),
                style: LelloTextStyles.bodyBold(theme))),
        Row(
          children: <Widget>[
            Expanded(
                child: _buildItem(theme, getString(context, "from"),
                    _timeToString(space.reservationRule.openHour) ?? "")),
            Expanded(
                child: _buildItem(theme, getString(context, "to"),
                    _timeToString(space.reservationRule.closeHour) ?? "")),
          ],
        ),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_default_duration"),
            _timeToString(space.reservationRule.defaultDuration) ?? ""),
        _buildItem(
            theme,
            getString(
                context, "space_registration_rule_time_between_reservations"),
            _timeToString(space.reservationRule.timeBetweenReservations) ?? ""),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_limitation"),
            _reservationLimitationTitle()),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_total_reservations"),
            _value(space.reservationRule.limit.toString()) ?? ""),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_range_maximum"),
            _value(space.reservationRule.reservationRangeMaximum.toString()) ??
                ""),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_range_minimum"),
            _value(space.reservationRule.reservationRangeMinimum.toString()) ??
                ""),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_send_email_manager"),
            _yesOrNoTitle(space.reservationRule.sendEmailToManager!)),
        _buildItem(
            theme,
            getString(context, "space_registration_rule_send_email_resident"),
            _yesOrNoTitle(space.reservationRule.sendEmailToResident!)),
        Divider(),
        _buildHeader(
            theme,
            getString(context, "space_registration_usage_title"),
            SpaceRegistrationStep.usage),
        _buildAttachment(theme, widget.space),
        _buildItem(
            theme, "Termo de responsabilidade", _value(space.term) ?? ""),
        Divider(),
        _buildHeader(
            theme,
            getString(context, "space_registration_charge_title"),
            SpaceRegistrationStep.charges),
        _buildItem(
            theme,
            getString(context, "space_registration_charge_chargeable"),
            _yesOrNoTitle(space.reservationRule.chargeable!)),
        Visibility(
          visible: space.reservationRule.chargeable!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildItem(
                  theme,
                  getString(
                      context, "space_registration_charge_payment_method"),
                  _paymentMethodTile()),
              _buildItem(
                  theme,
                  getString(context, "space_registration_charge_payment_value"),
                  _value(currencyFormat
                          .format(space.reservationRule.price)
                          .toString()) ??
                      ""),
              _buildItem(
                  theme,
                  getString(
                      context, "space_reservation_cancellation_limit_days"),
                  _value(space.reservationRule.cancellationLimit.toString()) ??
                      ""),
              _buildItem(
                  theme,
                  getString(context, "space_registration_charge_account"),
                  _value(space.reservationRule.account?.name) ?? ""),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHeader(
      ThemeData theme, String title, SpaceRegistrationStep step) {
    final index = SpaceRegistrationBloc.stepOrder.indexOf(step) + 1;
    return ListTile(
      title: Text(title, style: LelloTextStyles.subtitleBold(theme)),
      trailing: Visibility(
        visible: widget.showEdit,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                sprintf(getString(context, "register_payment_step"),
                    [index, SpaceRegistrationBloc.stepOrder.length - 2]),
                style: LelloTextStyles.subBody(theme)),
            SizedBox(width: Dimens.spacing),
            SecondaryButton(
                text: getString(context, "edit"),
                onPressed: () {
                  widget.onEditRequested.call(step);
                })
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ThemeData theme, String title, String? value) {
    return ListTile(
      title: Text(title, style: LelloTextStyles.bodyBold(theme)),
      subtitle: Text(value ?? "-", style: LelloTextStyles.body(theme)),
    );
  }

  Widget _buildAttachment(ThemeData theme, Space space) {
    if (space.pendingFile == null &&
        (space.fileUrl == null || space.fileUrl == "")) return Container();
    return ListTile(
      onTap: () {
        setState(() {
          space.pendingFile = null;
        });
      },
      leading: SvgPicture.asset("assets/ic_attachment.svg"),
      title: Text(space.pendingFile?.path.split('/').last ?? "Regulamento",
          style: LelloTextStyles.body(theme)),
      trailing: SvgPicture.asset("assets/ic_cancel.svg"),
    );
  }

  Widget _buildPreviewImage(ThemeData theme, File? picture) {
    if (picture == null) return Container();
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Row(children: [
        Stack(children: [
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                    fit: BoxFit.fitHeight, image: FileImage(picture))),
          ),
          Positioned(
            right: -16,
            top: -16,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.space.pendingPicture = null;
                });
              },
              child: SvgPicture.asset("assets/ic_cancel.svg"),
            ),
          )
        ]),
      ]),
    );
  }

  String? _timeToString(int? time) {
    final data = time?.toString().padLeft(4, "0");
    if (data == null) return data;

    return "${data.substring(0, 2)}:${data.substring(2)}";
  }

  String? _value(String? value) {
    if (value?.isNotEmpty == true) return value;
    return "-";
  }

  String _yesOrNoTitle(bool value) {
    if (value == true) return getString(context, "yes");
    return getString(context, "no");
  }

  String _paymentMethodTile() {
    switch (widget.space.reservationRule.paymentMethod) {
      case ReservationPaymentMethod.quota:
        return getString(context, "space_reservation_payment_quota");
      case ReservationPaymentMethod.billet:
        return getString(context, "space_reservation_payment_billet");
      default:
        return "-";
    }
  }

  String _reservationLimitationTitle() {
    switch (widget.space.reservationRule.limitation) {
      case ReservationLimitation.none:
        return getString(context, "space_registration_rule_limitation_none");
      case ReservationLimitation.day:
        return getString(context, "space_registration_rule_limitation_day");
      case ReservationLimitation.month:
        return getString(context, "space_registration_rule_limitation_month");
      case ReservationLimitation.year:
        return getString(context, "space_registration_rule_limitation_year");
      default:
        return "-";
    }
  }
}
