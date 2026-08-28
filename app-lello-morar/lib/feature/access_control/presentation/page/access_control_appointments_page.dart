import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_error_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_excluded_error.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_excluded_success.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_invite_success_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_success.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_appointments_card.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_delete_visitant_dialog.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class AccessControlAppointmentsPage extends StatefulWidget {
  final AccessControl accessControl;
  final AccessControlStore accessControlStore;
  final bool isGeneric;

  const AccessControlAppointmentsPage({
    Key? key,
    required this.accessControl,
    required this.accessControlStore,
    required this.isGeneric,
  }) : super(key: key);

  @override
  State<AccessControlAppointmentsPage> createState() =>
      _AccessControlAppointmentsPageState();
}

class _AccessControlAppointmentsPageState
    extends State<AccessControlAppointmentsPage> {
  late SessionBloc sessionBloc;
  final List<AccessControlAuthorizations> expiredsAuth = [];
  final List<AccessControlAuthorizations> activesAuth = [];
  @override
  void initState() {
    sessionBloc = ApplicationContainer.instance().resolve();
    widget.accessControl.gestUnits.forEach((element) {
      element.authorizations.forEach((auth) {
        DateTime now = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          0,
          0,
        );
        if (auth.endDate.isBefore(now) && auth.authType != "Interfonar") {
          expiredsAuth.add(auth);
        } else {
          activesAuth.add(auth);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(
          context,
          ApplicationRoute.accessControl,
          arguments: AcessControlPageArgs(
            tabIndex: widget.accessControl.type == "SERVICE" ? 1 : 0,
            isGeneric: widget.isGeneric,
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: WhiteAppBar(
          title: "access_control_title",
          isGetString: true,
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.accessControl,
              arguments: AcessControlPageArgs(
                tabIndex: widget.accessControl.type == "SERVICE" ? 1 : 0,
                isGeneric: widget.isGeneric,
              ),
            );
          },
        ),
        body: BlocConsumer(
          bloc: widget.accessControlStore.bloc,
          listener: (context, state) {
            if (state is SaveVisitantLoadedState) {
              if (state.sendInvite) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AccessControlInviteSuccessPage(
                      state: state,
                      isGeneric: widget.isGeneric,
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccessControlSendInviteSuccessPage(
                      accessControlStore: widget.accessControlStore,
                      isVisitant: state.isVisitant,
                      useFacialBiometric: state.useFacial,
                      isGeneric: widget.isGeneric,
                    ),
                  ),
                );
              }
            } else if (state is DeleteVisitantState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessControlExcludedSuccessPage(
                    accessControlStore: widget.accessControlStore,
                    isVisitant: state.visitant.prestador == false,
                    isGeneric: widget.isGeneric,
                  ),
                ),
              );
            } else if (state is SaveVisitantFailureState) {
              if (state.deletVisitant) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccessControlExcludedErrorPage(
                      accessControlStore: widget.accessControlStore,
                      accessControl: state.visitant,
                      model: state.model,
                      isGeneric: widget.isGeneric,
                      isVisitant: state.visitant.prestador == false,
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccessControlErrorPage(
                      accessControlStore: widget.accessControlStore,
                      accessControl: state.visitant,
                      model: state.model,
                      isAppointment: true,
                      isEdit: false,
                      isGeneric: widget.isGeneric,
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is AccessControlLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildVisitantInfos(theme, context),
                          if (activesAuth.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                  getString(context,
                                      "access_control_active_appointment"),
                                  style:
                                      LelloTextStyles.bodyBold(theme)!.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).hubText(),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                ...List.generate(
                                  activesAuth.length,
                                  (index) => Column(
                                    children: [
                                      AccessControlAppointmentsCard(
                                        accessControlStore:
                                            widget.accessControlStore,
                                        canEdit: true,
                                        authorization: activesAuth[index],
                                        accessControl: widget.accessControl,
                                        isGeneric: widget.isGeneric,
                                      ),
                                      SizedBox(height: Dimens.spacingMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (expiredsAuth.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                  getString(context,
                                      "access_control_history_appointment"),
                                  style:
                                      LelloTextStyles.bodyBold(theme)!.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).hubText(),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                ...List.generate(
                                  expiredsAuth.length,
                                  (index) => Column(
                                    children: [
                                      AccessControlAppointmentsCard(
                                        accessControlStore:
                                            widget.accessControlStore,
                                        isGeneric: widget.isGeneric,
                                        accessControl: widget.accessControl,
                                        authorization: expiredsAuth[index],
                                      ),
                                      SizedBox(height: Dimens.spacingMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  CircuitBreakerWidget(
                    reference:
                        sessionBloc.state.session?.condominium?.reference ?? "",
                    appContainer: ApplicationContainer.instance(),
                    applicationRbac: ApplicationRbac
                        .morarAutorizarEntradaCadastrarAgendamento,
                    rbacEnabled: sessionBloc.checkRback(ApplicationRbac
                        .morarAutorizarEntradaCadastrarAgendamento),
                    child: PrimaryButton(
                      text:
                          getString(context, "access_control_new_appointment"),
                      onPressed: () {
                        widget.accessControlStore.editVisitant(
                          visitant: widget.accessControl,
                          authorizations: AccessControlAuthorizations(
                            accessControl: widget.accessControl,
                          ),
                        );

                        Navigator.pushReplacementNamed(
                            context, ApplicationRoute.accessControlInsert,
                            arguments: AccessControlInsertPageArgs(
                              accessControlStore: widget.accessControlStore,
                              isGeneric: widget.isGeneric,
                              newVisit: true,
                              authorization: AccessControlAuthorizations(),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Row _buildVisitantInfos(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              child: SvgPicture.asset("assets/user_placeholder.svg", width: 32),
            ),
            SizedBox(width: Dimens.spacing),
            _buildInfo(theme, context),
          ],
        ),
        CircuitBreakerWidget(
          reference: sessionBloc.state.session?.condominium?.reference ?? "",
          appContainer: ApplicationContainer.instance(),
          applicationRbac: ApplicationRbac.morarAutorizarEntradaExcluirUsuario,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.morarAutorizarEntradaExcluirUsuario),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            padding: EdgeInsets.only(bottom: 10.0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AccessControlDeleteVisitantDialog(
                  sessionBloc: sessionBloc,
                  isVisitant: widget.accessControl.prestador == false,
                  onTap: () {
                    Navigator.pop(context);
                    widget.accessControlStore.deleteVisitant(
                        visitant: widget.accessControl,
                        authorizations: AccessControlAuthorizations(),
                        gestId: widget.accessControl.idGest ?? "");
                  },
                ),
              );
            },
            icon: Icon(
              Icons.delete_forever_outlined,
              color: theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildInfo(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.accessControl.name != null)
          Text(
            widget.accessControl.name!,
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.bodyBold(theme),
          ),
        if (widget.accessControl.name != null)
          SizedBox(height: Dimens.spacingXSmall),
        if (widget.accessControl.documentFormatted != null)
          Text(
            widget.accessControl.documentFormatted!,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        if (widget.accessControl.type == "SERVICE")
          Text(
            widget.accessControl.business ??
                getString(context, "access_control_provider"),
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
      ],
    );
  }
}
