import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_state.dart';

class ReservationCancelConfirmationPage extends StatelessWidget {
  final ReservationCancellationBloc bloc =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    Reservation model =
        ModalRoute.of(context)!.settings.arguments as Reservation;
    final theme = LelloTheme.dark;
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).warning(),
        body: BlocConsumer<ReservationCancellationBloc,
                ReservationCancellationState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is ReservationCancellationCancelledState) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) => Padding(
                  padding: EdgeInsets.all(Dimens.spacingLarge),
                  child: Center(
                    child: Visibility(
                      visible: state is! ReservationCancellationLoadingState,
                      replacement: const Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset("assets/ic_warning.svg",
                              width: 92, height: 92),
                          SizedBox(height: Dimens.spacingLarge),
                          Text(
                              getString(context,
                                  "space_reservation_cancellation_confirmation"),
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.headline(theme)),
                          SizedBox(height: Dimens.spacingLarge),
                          PrimaryButton(
                            text: getString(context, "yes"),
                            onPressed: () {
                              bloc.beginCancel(model);
                            },
                          ),
                          SizedBox(height: Dimens.spacing),
                          SecondaryButton(
                            text: getString(context, "no"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
