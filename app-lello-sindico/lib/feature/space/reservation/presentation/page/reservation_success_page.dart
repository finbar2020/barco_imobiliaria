import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/app_review/app_review.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

class ReservationSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Reservation? reservation =
        ModalRoute.of(context)!.settings.arguments as Reservation?;
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
                Text(getTitle(reservation, context),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
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
                        Navigator.pushNamedAndRemoveUntil(
                            context, ApplicationRoute.home, (route) => false);
                        AppReview.call(context: context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(Reservation? reservation, BuildContext context) {
    String key = "success";

    switch (reservation?.type!) {
      case ReservationType.reservation:
        key = "space_reservation_reservation_success";
        break;
      case ReservationType.maintenance:
        key = "space_reservation_maintenance_success";
        break;
      case ReservationType.raffle:
        key = "space_reservation_raffle_success";
        break;
      default:
        break;
    }

    return getString(context, key);
  }
}
