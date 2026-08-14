import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_error_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_error.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_success.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_success_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_info_widget.dart';

class AccessControlInsertPageArgs {
  final AccessControlStore accessControlStore;
  final bool newVisit;
  final bool isEdit;
  final bool isGeneric;
  final AccessControlAuthorizations authorization;
  AccessControlInsertPageArgs({
    required this.accessControlStore,
    required this.authorization,
    required this.isGeneric,
    this.newVisit = false,
    this.isEdit = false,
  });
}

class AccessControlInsertPage extends StatefulWidget {
  const AccessControlInsertPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AccessControlInsertPage> createState() =>
      _AccessControlInsertPageState();
}

class _AccessControlInsertPageState extends State<AccessControlInsertPage> {
  @override
  Widget build(BuildContext context) {
    AccessControlInsertPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as AccessControlInsertPageArgs;
    return Scaffold(
      appBar: WhiteAppBar(
        title: "access_control_register",
        isGetString: true,
        onPressed: () {
          (arguments.newVisit || arguments.isEdit) &&
                  arguments.accessControlStore.bloc.state is EditVisitantState
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccessControlAppointmentsPage(
                      accessControlStore: arguments.accessControlStore,
                      isGeneric: arguments.isGeneric,
                      accessControl: (arguments.accessControlStore.bloc.state
                              as EditVisitantState)
                          .visitant,
                    ),
                  ))
              : Navigator.pushReplacementNamed(
                  context,
                  ApplicationRoute.accessControl,
                  arguments:
                      AcessControlPageArgs(isGeneric: arguments.isGeneric),
                );
        },
      ),
      body: BlocConsumer(
        bloc: arguments.accessControlStore.bloc,
        builder: (context, state) {
          if (state is AccessControlLoadingState) {
            return FractionallySizedBox(
              heightFactor: 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is EditVisitantState) {
            return AccessControlVisitantInfoWidget(
              accessControlStore: arguments.accessControlStore,
              state: state,
              isGeneric: arguments.isGeneric,
              authorization: arguments.authorization,
              isEdit: arguments.isEdit,
              isVisitant: !state.visitant.prestador,
              newVisit: arguments.newVisit,
            );
          }
          return Container();
        },
        listener: (context, state) {
          if (state is SaveVisitantLoadedState) {
            if (state.newVisit) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessControlSuccessPage(
                    newVisit: true,
                    isVisitant: state.isVisitant,
                    isGeneric: arguments.isGeneric,
                  ),
                ),
              );
            } else if (state.edit) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessControlSuccessPage(
                    isEdit: true,
                    isVisitant: state.isVisitant,
                    isGeneric: arguments.isGeneric,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessControlSendInviteSuccessPage(
                    accessControlStore: arguments.accessControlStore,
                    isVisitant: state.isVisitant,
                    useFacialBiometric: state.useFacial,
                    isGeneric: arguments.isGeneric,
                  ),
                ),
              );
            }
          } else if (state is SaveVisitantFailureState) {
            if (state.failureInvite) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessControlErrorPage(
                    accessControlStore: arguments.accessControlStore,
                    accessControl: state.visitant,
                    model: state.model,
                    isAppointment: false,
                    isEdit: arguments.isEdit,
                    isGeneric: arguments.isGeneric,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessControlSendInviteErrorPage(
                    accessControlStore: arguments.accessControlStore,
                    accessControl: state.visitant,
                    model: state.model,
                    isEdit: arguments.isEdit,
                    isGeneric: arguments.isGeneric,
                  ),
                ),
              );
            }
          } else if (state is DeleteVisitState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AccessControlSuccessPage(
                  isDeleteVisit: true,
                  isVisitant: state.isVisitant,
                  isGeneric: arguments.isGeneric,
                ),
              ),
            );
          } else if (state is DeleteFailureVisitState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AccessControlErrorPage(
                  accessControlStore: arguments.accessControlStore,
                  accessControl: state.visitant,
                  model: state.model,
                  isDelete: true,
                  isAppointment: false,
                  isEdit: arguments.isEdit,
                  isGeneric: arguments.isGeneric,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
