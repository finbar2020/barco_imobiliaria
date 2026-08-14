import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_card.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class AccessControlProviderTab extends StatefulWidget {
  final AccessControlStore accessControlStore;
  final SessionBloc sessionBloc;
  final AcessControlPageArgs arguments;
  const AccessControlProviderTab({
    Key? key,
    required this.accessControlStore,
    required this.sessionBloc,
    required this.arguments,
  }) : super(key: key);

  @override
  State<AccessControlProviderTab> createState() =>
      _AccessControlProviderTabState();
}

class _AccessControlProviderTabState extends State<AccessControlProviderTab> {
  AccessControl accessControl = AccessControl(
    type: "SERVICE",
    gestUnits: [
      AccessControlGestUnits(
        authorizations: [],
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.accessControlStore.bloc.state is AccessControlLoadingState) {
      return LoadingWidget();
    }
    if (widget.accessControlStore.bloc.state is AccessControlLoadedState ||
        widget.accessControlStore.bloc.state is DeleteFailureVisitState ||
        widget.accessControlStore.bloc.state is SearchingVisitantState ||
        widget.accessControlStore.bloc.state is SearchingProviderState ||
        widget.accessControlStore.bloc.state is EditVisitantState ||
        widget.accessControlStore.bloc.state is EditVisitState ||
        widget.accessControlStore.bloc.state is SaveVisitantLoadedState) {
      return _buildLoadedProviderBody(
          context,
          widget.accessControlStore.bloc.state.providers,
          widget.accessControlStore,
          theme,
          widget.accessControlStore.bloc.state,
          widget.sessionBloc);
    }
    if (widget.accessControlStore.bloc.state is DeleteFailureVisitState ||
        widget.accessControlStore.bloc.state is AccessControlFailureState) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  getString(context, "warning_failed_message"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildLoadedProviderBody(
    BuildContext context,
    List<AccessControl> providers,
    AccessControlStore accessControlStore,
    ThemeData theme,
    AccessControlState state,
    SessionBloc sessionBloc,
  ) {
    if (!(state is SearchingProviderState)) {
      if (providers.isEmpty) {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    getString(context, "access_control_empty_provider_error"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            CircuitBreakerWidget(
              reference:
                  sessionBloc.state.session?.condominium?.reference ?? "",
              appContainer: ApplicationContainer.instance(),
              applicationRbac:
                  ApplicationRbac.morarAutorizarEntradaCadastrarUsuario,
              rbacEnabled: sessionBloc.checkRback(
                  ApplicationRbac.morarAutorizarEntradaCadastrarUsuario),
              child: _buildButton(
                context,
                theme,
                "access_control_new_providers",
                () {
                  accessControlStore.editVisitant(
                    visitant: accessControl,
                    authorizations: AccessControlAuthorizations(
                      accessControl: accessControl,
                    ),
                  );

                  Navigator.pushReplacementNamed(
                      context, ApplicationRoute.accessControlInsert,
                      arguments: AccessControlInsertPageArgs(
                        accessControlStore: accessControlStore,
                        isGeneric: widget.arguments.isGeneric,
                        authorization: AccessControlAuthorizations(),
                      ));
                },
              ),
            ),
          ],
        );
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.arguments.acessControlNotificationContext?.isNotEmpty ==
              true &&
          mounted) {
        var visitor = state.visitants.firstWhere(
            (element) =>
                element.notificationParameter ==
                    widget.arguments.acessControlNotificationContext ||
                element.idGest ==
                    widget.arguments.acessControlNotificationContext,
            orElse: () => AccessControl(name: "error"));
        var provider = state.providers.firstWhere(
            (element) =>
                element.notificationParameter ==
                    widget.arguments.acessControlNotificationContext ||
                element.idGest ==
                    widget.arguments.acessControlNotificationContext,
            orElse: () => AccessControl(name: "error"));
        if (visitor.name != "error")
          _showEditVisitor(accessControlStore, visitor, context);
        if (provider.name != "error")
          _showEditVisitor(accessControlStore, provider, context);
        widget.arguments.acessControlNotificationContext = null;
      }
    });
    List<AccessControlAuthorizations> expireds = [];
    List<AccessControlAuthorizations> actives = [];
    providers.forEach((element) {
      element.gestUnits.forEach((item) {
        item.authorizations.forEach((auth) {
          DateTime now = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            0,
            0,
          );
          auth.accessControl = element;
          if (auth.endDate.isBefore(now) && auth.authType != "Interfonar") {
            expireds.add(auth);
          } else {
            actives.add(auth);
          }
        });
      });
    });
    return DismissKeyboard(
      child: Column(
        children: [
          SizedBox(
            height: Dimens.spacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              onChanged: (value) {
                accessControlStore.visitantSearch(
                    name: value, visitant: providers, isProvider: true);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: getString(context, "find"),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: Dimens.spacingLarge,
          ),
          state is SearchingProviderState
              ? expireds.length > 0 || actives.length > 0
                  ? Expanded(
                      child: Container(
                        color: LelloTheme.palleteOf(theme).backgroundDark(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: SingleChildScrollView(
                          child: _buildLists(actives, context,
                              accessControlStore, expireds, theme),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                          getString(
                              context, "access_control_no_provider_found"),
                          textAlign: TextAlign.center),
                    )
              : Expanded(
                  child: Container(
                    width: double.infinity,
                    color: LelloTheme.palleteOf(theme).backgroundDark(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: expireds.length > 0 || actives.length > 0
                        ? SingleChildScrollView(
                            child: _buildLists(actives, context,
                                accessControlStore, expireds, theme),
                          )
                        : Center(
                            child: Text(
                                getString(context,
                                    "access_control_no_provider_found"),
                                textAlign: TextAlign.center),
                          ),
                  ),
                ),
          CircuitBreakerWidget(
            reference: sessionBloc.state.session?.condominium?.reference ?? "",
            appContainer: ApplicationContainer.instance(),
            applicationRbac:
                ApplicationRbac.morarAutorizarEntradaCadastrarUsuario,
            rbacEnabled: sessionBloc.checkRback(
                ApplicationRbac.morarAutorizarEntradaCadastrarUsuario),
            child: _buildButton(
              context,
              theme,
              "access_control_new_providers",
              () {
                accessControlStore.editVisitant(
                  visitant: accessControl,
                  authorizations: AccessControlAuthorizations(
                    accessControl: accessControl,
                  ),
                );

                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.accessControlInsert,
                    arguments: AccessControlInsertPageArgs(
                      accessControlStore: accessControlStore,
                      isGeneric: widget.arguments.isGeneric,
                      authorization: AccessControlAuthorizations(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _buildLists(
    List<AccessControlAuthorizations> actives,
    BuildContext context,
    AccessControlStore accessControlStore,
    List<AccessControlAuthorizations> expireds,
    ThemeData theme,
  ) {
    return Column(
      children: [
        ...List.generate(
            actives.length,
            (index) => Column(
                  children: [
                    AccessControlVisitantCard(
                      model: actives[index].accessControl!,
                      authorization: actives[index],
                      onTap: () {
                        var provider = actives[index].accessControl!;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AccessControlAppointmentsPage(
                                      isGeneric: widget.arguments.isGeneric,
                                      accessControlStore: accessControlStore,
                                      accessControl: provider),
                            ));
                      },
                    ),
                    SizedBox(
                      height: Dimens.spacing,
                    ),
                  ],
                )),
        if (expireds.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "access_control_reactive_schedule"),
                style: LelloTextStyles.bodyBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).textAccent(),
                ),
              ),
              SizedBox(
                height: Dimens.spacing,
              ),
              ...List.generate(
                  expireds.length,
                  (index) => Column(
                        children: [
                          Opacity(
                            opacity: 0.4,
                            child: AccessControlVisitantCard(
                              model: expireds[index].accessControl!,
                              authorization: expireds[index],
                              onTap: () {
                                var provider = expireds[index].accessControl!;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AccessControlAppointmentsPage(
                                              isGeneric:
                                                  widget.arguments.isGeneric,
                                              accessControlStore:
                                                  accessControlStore,
                                              accessControl: provider),
                                    ));
                              },
                            ),
                          ),
                          SizedBox(
                            height: Dimens.spacing,
                          ),
                        ],
                      )),
            ],
          )
      ],
    );
  }

  Container _buildButton(
    BuildContext context,
    ThemeData theme,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      height: Dimens.homeBalanceHeightCollapsed,
      width: double.infinity,
      child: Center(
          child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: LelloTheme.palleteOf(theme).textAccent(),
                    width: 2,
                  ),
                ),
                height: Dimens.spacingMedium,
                width: Dimens.spacingMedium,
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 16.0,
                    color: LelloTheme.palleteOf(theme).textAccent(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Dimens.spacingSmall,
            ),
            Text(
              getString(context, title),
              style: LelloTextStyles.subBody(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textAccent(),
                decoration: TextDecoration.underline,
                decorationColor: LelloTheme.palleteOf(theme).textAccent(),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _showEditVisitor(AccessControlStore accessControlStore,
      AccessControl visitor, BuildContext context) {
    accessControlStore.editVisitant(
      visitant: visitor,
      authorizations: AccessControlAuthorizations(
        accessControl: visitor,
      ),
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccessControlAppointmentsPage(
            accessControlStore: accessControlStore,
            isGeneric: widget.arguments.isGeneric,
            accessControl: visitor,
          ),
        ));
  }
}
