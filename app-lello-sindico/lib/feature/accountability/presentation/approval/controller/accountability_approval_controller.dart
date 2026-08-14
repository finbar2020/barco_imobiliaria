// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/accountability/domain/use_case/approve_accountability/approve_accountability_usecase.dart';
import 'package:lello/feature/accountability/presentation/approval/bloc/accountability_approval_bloc.dart';

import 'package:essentials/analytics/events/analytics_events_manager.dart';

import '../../../../../core/analytics/analytics_log_events.dart';
import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../domain/entity/accountability.dart';
import '../bloc/accountability_approval_event.dart';

class AccountabilityApprovalController {
  final AccountabilityApprovalBloc bloc;
  final ApproveAccountabilityUsecase approveAccountabilityUsecase;
  final SessionBloc sessionBloc;

  AccountabilityApprovalController({
    required this.bloc,
    required this.approveAccountabilityUsecase,
    required this.sessionBloc,
  });

  Future<void> approve({required Accountability accountability}) async {
    bloc.add(AccountabilityApprovalLoadingEvent());

    final result = await approveAccountabilityUsecase(accountability);
    result.fold(
      (failure) => bloc.add(AccountabilityApprovalFailedEvent(failure)),
      (success) {
        bloc.add(AccountabilityApprovalApprovedEvent(approval: success));
        String reference = sessionBloc
                .state.session!.selectedCondominium?.reference
                .toString() ??
            "";
        ManagerAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.aprovarPpcFinalizado(),
            referenceValue: reference,
            otherParameters: {
              "mes": DateTime.utc(
                success.date!.year,
                success.date!.month,
              ).toString()
            });
      },
    );
  }

  Future<void> setup({required Accountability accountability}) async {
    String reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";
    ManagerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsManager.aprovarPpcAcessar(),
      referenceValue: reference,
      otherParameters: {
        "mes": DateTime.utc(
          accountability.period!.year,
          accountability.period!.month,
        ).toString()
      },
    );
  }
}
