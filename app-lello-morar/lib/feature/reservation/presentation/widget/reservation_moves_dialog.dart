import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';

class ReservationMovesDialog extends StatefulWidget {
  final LoadedDialogState state;
  final ReservationBloc bloc;
  const ReservationMovesDialog(
      {Key? key, required this.state, required this.bloc})
      : super(key: key);

  @override
  State<ReservationMovesDialog> createState() => _ReservationMovesDialogState();
}

class _ReservationMovesDialogState extends State<ReservationMovesDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_reservas_gratis.svg"),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              "${widget.state.space.name} \n ${DateFormat.yMd().format(widget.state.reserveDate)}",
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)!
                  .copyWith(color: theme.primaryColor),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              '${widget.state.session?.condominium?.name ?? ''} - ${widget.state.session?.unity?.title ?? ''}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: LelloTextStyles.caption(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "cancel").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    DateTime start = DateTime(
                      widget.state.reserveDate.year,
                      widget.state.reserveDate.month,
                      widget.state.reserveDate.day,
                      int.parse(widget.state.hour.from.substring(0, 2)),
                      int.parse(widget.state.hour.from.substring(3, 5)),
                    );
                    DateTime end = DateTime(
                      widget.state.reserveDate.year,
                      widget.state.reserveDate.month,
                      widget.state.reserveDate.day,
                      int.parse(widget.state.hour.until.substring(0, 2)),
                      int.parse(widget.state.hour.until.substring(3, 5)),
                    );
                    widget.bloc.postReservation(
                      ReservationRegistration(
                        spaceId: widget.state.space.id,
                        space: widget.state.space,
                        unitId: widget.state.session!.unity!.id,
                        idStatus: 83,
                        reservationStartDate: start.toIso8601String(),
                        reservationEndDate: end.toIso8601String(),
                        flagUtilityTerm: true,
                        reservationType: widget.state.space.type!.description,
                      ),
                      widget.state.reserveDate,
                      widget.state.hour,
                    );
                  },
                  child: Text(
                    getString(context, "confirm").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).success(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
