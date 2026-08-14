import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_event.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BenefitsBloc extends Bloc<BenefitsEvent, BenefitsState> {
  final GetDocumentsInfoListUseCase getDocumentsInfoListUseCase;
  final SessionBloc sessionBloc;

  BenefitsBloc({
    required this.getDocumentsInfoListUseCase,
    required this.sessionBloc,
  }) : super(const BenefitsInitialState()) {
    on<GetDocumentsInfoListEvent>(_mapGetDocumentsInfoList);
    getDocumentsInfoList(documentType: DocumentTypeEnum.protocolBenefits);
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
    Emitter<BenefitsState> emit,
  ) async {
    emit(const BenefitsLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getDocumentsInfoListUseCase.call(
        GetDocumentsInfoListParam(
            condoId: condoId,
            documentType: event.documentType,
            dateFrom: event.dateFrom,
            dateTo: event.dateTo));

    BenefitsState response = result.fold(
      (error) => BenefitsFailedState(
        errorDescription: error.error ?? "",
        errorCode: error.code.toString(),
      ),
      (res) => BenefitsLoadedState(res),
    );

    emit(response);
  }
}
