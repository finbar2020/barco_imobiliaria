import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_event.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayStubBloc extends Bloc<PayStubEvent, PayStubState> {
  final GetDocumentsInfoListUseCase getDocumentsInfoListUseCase;
  final SessionBloc sessionBloc;

  PayStubBloc({
    required this.getDocumentsInfoListUseCase,
    required this.sessionBloc,
  }) : super(const PayStubInitialState()) {
    on<GetDocumentsInfoListEvent>(_mapGetDocumentsInfoList);
    getDocumentsInfoList(documentType: DocumentTypeEnum.payStub);
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
    Emitter<PayStubState> emit,
  ) async {
    emit(const PayStubLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getDocumentsInfoListUseCase.call(
        GetDocumentsInfoListParam(
            condoId: condoId,
            documentType: event.documentType,
            dateFrom: event.dateFrom,
            dateTo: event.dateTo));

    PayStubState response = result.fold(
      (error) {
        return PayStubFailedState(
          errorDescription: error.error ?? "",
          errorCode: error.code.toString(),
        );
      },
      (res) => PayStubLoadedState(res),
    );

    emit(response);
  }
}
