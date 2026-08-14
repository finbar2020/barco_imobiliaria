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
import 'legal_obligation_bloc.dart';
import 'legal_obligation_event.dart';
import 'legal_obligation_state.dart';

class LegalObligationBlocImpl
    extends Bloc<LegalObligationEvent, LegalObligationState>
    implements LegalObligationBloc {
  final GetLegalObligationsUseCase getLegalObligationsUseCase;
  final DownloadLegalObligationFileUseCase downloadLegalObligationFileUseCase;
  final UploadLegalObligationFileUseCase uploadLegalObligationFileUseCase;
  final SendTechnicalInspectionEmailUseCase sendTechnicalInspectionEmailUseCase;
  final RequestLegalObligationRenewalUseCase
      requestLegalObligationRenewalUseCase;
  final MaintenanceManagementRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  LegalObligationBlocImpl(
    this.getLegalObligationsUseCase,
    this.downloadLegalObligationFileUseCase,
    this.uploadLegalObligationFileUseCase,
    this.sendTechnicalInspectionEmailUseCase,
    this.requestLegalObligationRenewalUseCase,
    this.repository,
    this.awsUploadFileUsecase,
  ) : super(const LegalObligationLoadingState(LegalObligationTab.condominium)) {
    on<LegalObligationLoadingEvent>((event, emit) {
      // no-op: tab-specific loading is handled via LegalObligationLoadTabEvent
    });
    on<LegalObligationLoadTabEvent>((event, emit) async {
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
    });
    on<LegalObligationErrorEvent>((event, emit) {
      emit(LegalObligationErrorState(event.error));
    });
    on<LegalObligationDownloadFileEvent>((event, emit) async {
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
    });
    on<LegalObligationUploadFileEvent>((event, emit) async {
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
    });
    on<LegalObligationSendTechnicalInspectionEmailEvent>((event, emit) async {
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
    });

    on<LegalObligationRequestPartnerRenewalEvent>((event, emit) async {
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
    });

    on<LegalObligationNotifyPartnerEmptyDataEvent>((event, emit) async {
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
    });
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
