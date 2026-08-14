import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

import '../../../domain/enum/legal_obligation_type.dart';
import '../../../domain/entity/legal_obligation_entity.dart';
import '../../../domain/use_cases/get_legal_obligations_use_case.dart';
import '../../../domain/use_cases/download_legal_obligation_file_use_case.dart';
import '../../../domain/use_cases/send_technical_inspection_email_use_case.dart';
import '../../../domain/use_cases/request_legal_obligation_renewal_use_case.dart';
import '../../../domain/use_cases/upload_legal_obligation_file_use_case.dart';
import '../../../domain/repository/maintenance_management_repository.dart';
import '../enums/legal_obligation_tab.dart';
import 'legal_obligation_event.dart';
import 'legal_obligation_state.dart';

class LegalObligationBloc
    extends Bloc<LegalObligationEvent, LegalObligationState> {
  final GetLegalObligationsUseCase getLegalObligationsUseCase;
  final DownloadLegalObligationFileUseCase downloadLegalObligationFileUseCase;
  final UploadLegalObligationFileUseCase uploadLegalObligationFileUseCase;
  final SendTechnicalInspectionEmailUseCase sendTechnicalInspectionEmailUseCase;
  final RequestLegalObligationRenewalUseCase
      requestLegalObligationRenewalUseCase;
  final MaintenanceManagementRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  LegalObligationBloc(
    this.getLegalObligationsUseCase,
    this.downloadLegalObligationFileUseCase,
    this.uploadLegalObligationFileUseCase,
    this.sendTechnicalInspectionEmailUseCase,
    this.requestLegalObligationRenewalUseCase,
    this.repository,
    this.awsUploadFileUsecase,
  ) : super(const LegalObligationLoadingState(LegalObligationTab.condominium)) {
    on<LegalObligationLoadingEvent>(_onLoading);
    on<LegalObligationLoadTabEvent>(_onLoadTab);
    on<LegalObligationErrorEvent>(_onError);
    on<LegalObligationDownloadFileEvent>(_onDownloadFile);
    on<LegalObligationUploadFileEvent>(_onUploadFile);
    on<LegalObligationSendTechnicalInspectionEmailEvent>(
        _onSendTechnicalInspectionEmail);
    on<LegalObligationRequestPartnerRenewalEvent>(
        _onRequestPartnerRenewal);
    on<LegalObligationNotifyPartnerEmptyDataEvent>(
        _onNotifyPartnerEmptyData);
  }

  void _onLoading(
    LegalObligationLoadingEvent event,
    Emitter<LegalObligationState> emit,
  ) {
    // no-op: tab-specific loading é tratado via LegalObligationLoadTabEvent
  }

  Future<void> _onLoadTab(
    LegalObligationLoadTabEvent event,
    Emitter<LegalObligationState> emit,
  ) async {
    emit(LegalObligationLoadingState(event.tab));

    final request = _requestForTab(event.tab);
    if (request == null) {
      emit(LegalObligationLoadedState(
        event.tab,
        const LegalObligationEntity.empty(),
      ));
      return;
    }

    final result = await getLegalObligationsUseCase(request);
    result.fold(
      (failure) {
        emit(LegalObligationErrorState(failure.error.toString()));
      },
      (data) {
        emit(LegalObligationLoadedState(event.tab, data));
      },
    );
  }

  void _onError(
    LegalObligationErrorEvent event,
    Emitter<LegalObligationState> emit,
  ) {
    emit(LegalObligationErrorState(event.error));
  }

  Future<void> _onDownloadFile(
    LegalObligationDownloadFileEvent event,
    Emitter<LegalObligationState> emit,
  ) async {
    emit(const LegalObligationDownloadingFileState());

    final result = await downloadLegalObligationFileUseCase(
      DownloadLegalObligationFileRequest(id: event.id, type: event.type),
    );

    result.fold(
      (failure) {
        emit(LegalObligationDownloadErrorState(failure.error.toString()));
      },
      (file) {
        emit(LegalObligationDownloadSuccessState(file));
      },
    );
  }

  Future<void> _onUploadFile(
    LegalObligationUploadFileEvent event,
    Emitter<LegalObligationState> emit,
  ) async {
    emit(const LegalObligationUploadingFileState());

    final dateStr = '${event.expirationDate.year.toString().padLeft(4, '0')}-'
        '${event.expirationDate.month.toString().padLeft(2, '0')}-'
        '${event.expirationDate.day.toString().padLeft(2, '0')}';

    final uploadResult = await awsUploadFileUsecase(
      AwsUploadFileParam(
        getUrlUploadS3: () =>
            repository.getLegalObligationUploadUrl(event.condoId),
        uploadFileToS3: (File file, String url) =>
            repository.uploadFileToS3(file, url),
        file: event.file,
      ),
    );

    await uploadResult.fold(
      (failure) async {
        emit(LegalObligationUploadErrorState(failure.error.toString()));
      },
      (urlUploadS3) async {
        final bffResult = await uploadLegalObligationFileUseCase(
          UploadLegalObligationFileRequest(
            type: event.obligationType,
            id: event.obligationId,
            fileName: urlUploadS3.fileName,
            fileUrl: urlUploadS3.url,
            date: dateStr,
          ),
        );

        bffResult.fold(
          (failure) {
            emit(LegalObligationUploadErrorState(failure.error.toString()));
          },
          (_) {
            emit(const LegalObligationUploadSuccessState());
          },
        );
      },
    );
  }

  Future<void> _onSendTechnicalInspectionEmail(
    LegalObligationSendTechnicalInspectionEmailEvent event,
    Emitter<LegalObligationState> emit,
  ) async {
    emit(const LegalObligationSendingEmailState());

    final result = await sendTechnicalInspectionEmailUseCase(
      SendTechnicalInspectionEmailRequest(
        type: event.type,
        id: event.id,
        email: event.email,
      ),
    );

    result.fold(
      (failure) {
        emit(LegalObligationEmailErrorState(failure.error.toString()));
      },
      (_) {
        emit(const LegalObligationEmailSentState());
      },
    );
  }

  Future<void> _onRequestPartnerRenewal(
    LegalObligationRequestPartnerRenewalEvent event,
    Emitter<LegalObligationState> emit,
  ) async {
    emit(const LegalObligationRequestingPartnerRenewalState());

    final result = await requestLegalObligationRenewalUseCase(
      RequestLegalObligationRenewalRequest(
        type: event.type,
        id: event.id,
      ),
    );

    result.fold(
      (failure) {
        emit(
          LegalObligationPartnerRenewalErrorState(failure.error.toString()),
        );
      },
      (_) {
        emit(const LegalObligationPartnerRenewalSuccessState());
      },
    );
  }

  Future<void> _onNotifyPartnerEmptyData(
    LegalObligationNotifyPartnerEmptyDataEvent event,
    Emitter<LegalObligationState> emit,
  ) async {
    emit(LegalObligationNotifyPartnerEmptyDataSendingState(event.type));

    final result = await repository.notifyLegalObligationPartner(
      type: event.type,
    );

    result.fold(
      (failure) {
        emit(
          LegalObligationNotifyPartnerEmptyDataErrorState(
            type: event.type,
            message: failure.error.toString(),
            shouldLockButton: false,
          ),
        );
      },
      (notifyResult) {
        if (notifyResult.success) {
          emit(
            LegalObligationNotifyPartnerEmptyDataSuccessState(
              type: event.type,
              shouldLockButton: notifyResult.shouldLockButton,
            ),
          );
          return;
        }

        emit(
          LegalObligationNotifyPartnerEmptyDataErrorState(
            type: event.type,
            message: notifyResult.message ?? 'Erro ao notificar parceiro',
            shouldLockButton: notifyResult.shouldLockButton,
          ),
        );
      },
    );
  }

  GetLegalObligationsRequest? _requestForTab(LegalObligationTab tab) {
    switch (tab) {
      case LegalObligationTab.condominium:
        return const GetLegalObligationsRequest(
          type: LegalObligationType.condominium,
        );
      case LegalObligationTab.employee:
        return const GetLegalObligationsRequest(
          type: LegalObligationType.employee,
        );
      case LegalObligationTab.technicalInspection:
        return const GetLegalObligationsRequest(
          type: LegalObligationType.technicalInspection,
        );
    }
  }
}
