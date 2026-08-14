import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccessControlSuccessPage extends StatelessWidget {
  final bool isEdit;
  final bool newVisit;
  final bool isDeleteVisit;
  final bool isVisitant;
  final bool isGeneric;
  const AccessControlSuccessPage({
    Key? key,
    this.isEdit = false,
    this.newVisit = false,
    this.isDeleteVisit = false,
    this.isVisitant = false,
    required this.isGeneric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
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
                SizedBox(height: 100.0),
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                if (isEdit)
                  Text(getString(context, "access_control_schedule_changed"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                if (newVisit)
                  Text(getString(context, "access_control_schedule_created"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                if (isDeleteVisit)
                  Text(getString(context, "access_control_schedule_delete"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 54.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                getString(context, "conclude"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                OwnerAnalyticsLogEvents.logEvent(
                  event: AnalyticsEventsOwner
                      .autorizacaoEntradasAgendamentosSucesso(),
                  userId: sessionBloc.state.session?.me?.id ?? "",
                  unitValue:
                      sessionBloc.state.session!.unity?.title.toString() ?? "",
                  referenceValue: sessionBloc
                          .state.session!.condominium?.reference
                          ?.toString() ??
                      "",
                );
                AppReview.call(context: context);
                Navigator.pushReplacementNamed(
                  context,
                  ApplicationRoute.accessControl,
                  arguments: AcessControlPageArgs(
                    tabIndex: isVisitant ? 0 : 1,
                    isGeneric: isGeneric,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
