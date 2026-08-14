import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';

class ReservationDeletedPage extends StatelessWidget {
  const ReservationDeletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ReservationCalendarBloc bloc =
        ApplicationContainer.instance().resolve();

    return Theme(
      data: theme,
      child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).warning(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_warning.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text("Agendamento cancelado com sucesso.",
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
                          bloc.beginLoadCalendarHistory();
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
