import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';

class ReservationRaffleDrawSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ReservationRaffleResult result =
        ModalRoute.of(context)!.settings.arguments as ReservationRaffleResult;
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
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                    getString(context, "space_reservation_raffle_draw_success"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "space_reservation_raffle_draw_winner"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.title(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Text(result.winner?.name ?? "-",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacing),
                Text(
                    "${result.winner?.unit?.title ?? "-"} - ${result.winner?.unit?.group ?? ""}",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                      buttonColor: Colors.white,
                      text: getString(context, "close"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
