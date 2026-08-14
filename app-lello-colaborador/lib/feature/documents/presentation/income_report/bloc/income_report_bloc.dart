import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_event.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeReportBloc extends Bloc<IncomeReportEvent, IncomeReportState> {
  final GetDocumentsInfoListUseCase getDocumentsInfoListUseCase;
  final SessionBloc sessionBloc;

  IncomeReportBloc({
    required this.getDocumentsInfoListUseCase,
    required this.sessionBloc,
  }) : super(const IncomeReportInitialState()) {
    on<GetDocumentsInfoListEvent>(_mapGetDocumentsInfoList);
    getDocumentsInfoList(documentType: DocumentTypeEnum.incomeReport);
  }

  void getDocumentsInfoList({
    required DocumentTypeEnum documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    add(GetDocumentsInfoListEvent(
      documentType: documentType,
      dateFrom: dateFrom,
      dateTo: dateTo,
    ));
  }

  Future<void> _mapGetDocumentsInfoList(
    GetDocumentsInfoListEvent event,
    Emitter<IncomeReportState> emit,
  ) async {
    emit(const IncomeReportLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getDocumentsInfoListUseCase.call(
        GetDocumentsInfoListParam(
            condoId: condoId,
            documentType: event.documentType,
            dateFrom: event.dateFrom,
            dateTo: event.dateTo));

    IncomeReportState response = result.fold(
      (error) {
        return IncomeReportFailedState(
          errorDescription: error.error ?? "",
          errorCode: error.code.toString(),
        );
      },
      (res) => IncomeReportLoadedState(res),
    );
    EmployeeAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsEmployee.documentosBeneficiosAcessar(),
      referenceValue:
          sessionBloc.getSession?.condominium.reference.toString() ?? "",
    );
    emit(response);
  }
}
