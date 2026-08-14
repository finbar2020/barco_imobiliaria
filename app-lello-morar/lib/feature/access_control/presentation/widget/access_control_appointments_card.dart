import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_stauts_biometric_enum.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class AccessControlAppointmentsCard extends StatefulWidget {
  final AccessControl accessControl;
  final AccessControlAuthorizations authorization;
  final bool canEdit;
  final AccessControlStore accessControlStore;
  final bool isGeneric;
  const AccessControlAppointmentsCard({
    Key? key,
    required this.accessControl,
    required this.authorization,
    this.canEdit = false,
    required this.accessControlStore,
    required this.isGeneric,
  }) : super(key: key);

  @override
  State<AccessControlAppointmentsCard> createState() =>
      _AccessControlAppointmentsCardState();
}

class _AccessControlAppointmentsCardState
    extends State<AccessControlAppointmentsCard> {
  @override
  Widget build(BuildContext context) {
    SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    DateFormat format = DateFormat("dd/MM/yyyy");
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).customColor(),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.authorization.authType,
                  style: LelloTextStyles.body(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacingSmall),
                widget.authorization.authType == "Interfonar"
                    ? Text(
                        getString(context, "access_control_phone_approved"),
                        style: LelloTextStyles.subtitle(theme)!.copyWith(),
                      )
                    : widget.authorization.authType == "Pontual"
                        ? Text(
                            "${getString(context, "accountability_date")}: ${format.format(widget.authorization.endDate)}",
                            style: LelloTextStyles.subtitle(theme)!.copyWith(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${getString(context, "from")}: ${format.format(widget.authorization.startDate)}",
                                style: LelloTextStyles.subtitle(theme),
                              ),
                              Text(
                                "${getString(context, "payment_filter_to")}: ${format.format(widget.authorization.endDate)}",
                                style: LelloTextStyles.subtitle(theme),
                              ),
                              Text(
                                "${getString(context, "access_control_days")}: ${widget.authorization.getRecurrenceDays}",
                                style: LelloTextStyles.subtitle(theme),
                              )
                            ],
                          ),
                if (widget.canEdit &&
                    sessionBloc.state.session?.condominium?.useFacialBiometric ==
                        true &&
                    widget.authorization.useFacialBiometric == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.spacing),
                      widget.accessControl.statusBiometric ==
                              StatusBiometric.CADASTRADA
                          ? Container(
                              decoration: BoxDecoration(
                                color: LelloTheme.palleteOf(theme).success(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                getString(context,
                                    "access_control_biometric_registered"),
                                style: LelloTextStyles.subtitleBold(theme)!
                                    .copyWith(color: Colors.white),
                              ),
                            )
                          : PrimaryButton(
                              height: 30.0,
                              onPressed: () {
                                widget.accessControlStore.sendInviteAccess(
                                    visitant: widget.accessControl,
                                    authorizations: widget.authorization);
                              },
                              text: getString(context,
                                  "access_control_send_biometric_invide"),
                            ),
                    ],
                  )
              ], //185993
            ),
          ),
          if (widget.canEdit)
            CircuitBreakerWidget(
              reference:
                  sessionBloc.state.session?.condominium?.reference ?? "",
              appContainer: ApplicationContainer.instance(),
              applicationRbac:
                  ApplicationRbac.morarAutorizarEntradaEditarAgendamento,
              rbacEnabled: sessionBloc.checkRback(
                  ApplicationRbac.morarAutorizarEntradaEditarAgendamento),
              child: InkWell(
                onTap: () {
                  widget.accessControlStore.editVisitant(
                      visitant: widget.accessControl,
                      authorizations: widget.authorization);

                  Navigator.pushReplacementNamed(
                      context, ApplicationRoute.accessControlInsert,
                      arguments: AccessControlInsertPageArgs(
                        accessControlStore: widget.accessControlStore,
                        isEdit: true,
                        isGeneric: widget.isGeneric,
                        authorization: widget.authorization,
                      ));
                },
                child: Icon(
                  Icons.edit,
                  color: theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
