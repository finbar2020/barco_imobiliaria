import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/use_case/get_nonpayments.dart';
import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_bloc.dart';
import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class NonPaymentController {
  final SessionBloc sessionBloc;
  final GetNonPayments getNonPaymentsUseCase;
  final NonPaymentsBloc nonPaymentsBloc;
  final DateFormat dateFormat = DateFormat("yyyyMM");
  NonPaymentController(
      {required this.sessionBloc,
      required this.getNonPaymentsUseCase,
      required this.nonPaymentsBloc});

  Future<void> getNonPayments() async {
    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";
    String condominiumName =
        sessionBloc.state.session?.selectedCondominium!.name ?? "";
    nonPaymentsBloc.add(
      NonPaymentsLoadingEvent(),
    );

    final response = await getNonPaymentsUseCase.call(
      GetNonPaymentsParam(
        condominiumId: condominiumId,
        period: dateFormat.format(
          DateTime.now(),
        ),
      ),
    );

    response.fold(
      (error) => nonPaymentsBloc.add(
        NonPaymentsLoadFailedEvent(error: error),
      ),
      (response) => nonPaymentsBloc.add(
        NonPaymentsLoadedEvent(
            payments: response, condominiumName: condominiumName),
      ),
    );
  }
}
