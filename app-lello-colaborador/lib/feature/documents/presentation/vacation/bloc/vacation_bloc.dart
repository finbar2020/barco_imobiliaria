import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_event.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VacationBloc extends Bloc<VacationEvent, VacationState> {
  final GetDocumentsInfoListUseCase getDocumentsInfoListUseCase;
  final SessionBloc sessionBloc;

  VacationBloc({
    required this.getDocumentsInfoListUseCase,
    required this.sessionBloc,
  }) : super(const VacationInitialState()) {
    on<GetDocumentsInfoListEvent>(_mapGetDocumentsInfoList);
    getDocumentsInfoList(documentType: DocumentTypeEnum.vacationReceipt);
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
    Emitter<VacationState> emit,
  ) async {
    emit(const VacationLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getDocumentsInfoListUseCase.call(
        GetDocumentsInfoListParam(
            condoId: condoId,
            documentType: event.documentType,
            dateFrom: event.dateFrom,
            dateTo: event.dateTo));

    VacationState response = result.fold(
      (error) {
        return VacationFailedState(
          errorDescription: error.error ?? "",
          errorCode: error.code.toString(),
        );
      },
      (res) => VacationLoadedState(res),
    );

    emit(response);
  }
}
