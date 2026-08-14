import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetDetailIntroWidget extends StatelessWidget {
  final DateTime period;
  const TimesheetDetailIntroWidget({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "${getString(context, "timesheet_detail_title")} - ${DateFormat('dd/MM/yyyy').format(period)}",
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    EmployeeAnalyticsLogEvents.logEvent(
                      event: AnalyticsEventsEmployee
                          .pontoDigitalInformacoesAcessar(),
                      referenceValue: sessionBloc
                              .getSession?.condominium.reference
                              .toString() ??
                          "",
                    );
                    Navigator.pushNamed(
                        context, ApplicationRoute.timesheetInfo);
                  },
                  child: const Icon(Icons.info_outline,
                      color: Colors.grey, size: 32.0)),
            )
          ],
        ),
        SizedBox(height: Dimens.spacing),
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "${getString(context, "digital_point_attention")}: ",
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
          ),
          TextSpan(
            text: getString(context, "digital_point_attention_description"),
            style: LelloTextStyles.subtitle(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
          ),
        ])),
      ],
    );
  }
}
