import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_state.dart';
import 'package:shared_features/shared_features.dart';

class TimesheetNotAllowedWarningArgs {
  TimesheetMenuBloc timesheetMenuBloc;
  TimesheetNotAllowedWarningArgs(this.timesheetMenuBloc);
}

class TimesheetNotAllowedWarning extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  const TimesheetNotAllowedWarning({Key? key, required this.appContainer})
      : super(key: key);

  @override
  State<TimesheetNotAllowedWarning> createState() =>
      _TimesheetNotAllowedWarningState();
}

class _TimesheetNotAllowedWarningState
    extends State<TimesheetNotAllowedWarning> {
  late TimesheetMenuBloc bloc;
  @override
  void initState() {
    bloc = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.dark;
    // TimesheetMenuBloc bloc = ApplicationContainer.instance().resolve();
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).warning(),
        body: BlocProvider.value(
          value: bloc,
          child: BlocConsumer<TimesheetMenuBloc, TimesheetMenuState>(
            listener: (context, state) {
              if (state is TimesheetRequestLoadedState) {
                pushNamedAndPopUntil(
                    context,
                    SharedApplicationRoute.gdpTimesheetRequestSuccess,
                    ModalRoute.withName(SharedApplicationRoute.home));
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingLarge),
                child: Center(
                  child: SingleChildScrollView(
                    child: state is TimesheetMenuReportLoadingState ||
                            state is TimesheetMenuEmployeesLoadingState
                        ? Padding(
                            padding: EdgeInsets.all(Dimens.spacingLarge),
                            child: Center(
                                child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset("assets/ic_warning.svg",
                                  width: 92, height: 92),
                              SizedBox(height: Dimens.spacingLarge),
                              _buildNotAllowed(theme, context),
                              SizedBox(height: Dimens.spacingXLarge),
                              state is TimesheetRequestLoadFailedState
                                  ? Padding(
                                      padding:
                                          EdgeInsets.all(Dimens.spacingMedium),
                                      child: Center(
                                        child: Text(
                                          "Ocorreu um erro ao enviar o email, tente novamente mais tarde",
                                          style: LelloTextStyles.error(theme),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              state is TimesheetRequestLoadingState
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ))
                                  : PrimaryButton(
                                      text: "Solicite o Ponto Digital",
                                      onPressed: () async {
                                        bloc.beginRequest();
                                        // Navigator.pop(context);
                                      }),
                              SizedBox(height: Dimens.spacing),
                              Theme(
                                data: theme.copyWith(
                                  textTheme: theme.textTheme.copyWith(
                                      labelLarge: theme.textTheme.labelLarge
                                          ?.copyWith(color: Colors.black)),
                                ),
                                child: PrimaryButton(
                                    buttonColor: Colors.white,
                                    text: getString(context, "back"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotAllowed(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(getString(context, "gdp_timesheet_warning_title"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.headline(theme)),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "gdp_timesheet_warning_subtitle"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.subtitle(theme)),
      ],
    );
  }
}
