import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';

import '../enums/legal_obligation_tab.dart';
import '../../../domain/entity/legal_obligation_entity.dart';

abstract class LegalObligationState extends Equatable {
  const LegalObligationState();

  @override
  List<Object?> get props => [];
}

class LegalObligationLoadingState extends LegalObligationState {
  final LegalObligationTab tab;

  const LegalObligationLoadingState(this.tab);

  @override
  List<Object?> get props => [tab];
}

class LegalObligationLoadedState extends LegalObligationState {
  final LegalObligationTab tab;
  final LegalObligationEntity data;

  const LegalObligationLoadedState(this.tab, this.data);

  @override
  List<Object?> get props => [tab, data];
}

class LegalObligationErrorState extends LegalObligationState {
  final String message;

  const LegalObligationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LegalObligationDownloadingFileState extends LegalObligationState {
  const LegalObligationDownloadingFileState();
}

class LegalObligationDownloadSuccessState extends LegalObligationState {
  final XFile file;

  const LegalObligationDownloadSuccessState(this.file);

  @override
  List<Object?> get props => [file];
}

class LegalObligationDownloadErrorState extends LegalObligationState {
  final String message;

  const LegalObligationDownloadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LegalObligationUploadingFileState extends LegalObligationState {
  const LegalObligationUploadingFileState();
}

class LegalObligationUploadSuccessState extends LegalObligationState {
  const LegalObligationUploadSuccessState();
}

class LegalObligationUploadErrorState extends LegalObligationState {
  final String message;

  const LegalObligationUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LegalObligationSendingEmailState extends LegalObligationState {
  const LegalObligationSendingEmailState();
}

class LegalObligationEmailSentState extends LegalObligationState {
  const LegalObligationEmailSentState();
}

class LegalObligationEmailErrorState extends LegalObligationState {
  final String message;

  const LegalObligationEmailErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LegalObligationRequestingPartnerRenewalState
    extends LegalObligationState {
  const LegalObligationRequestingPartnerRenewalState();
}

class LegalObligationPartnerRenewalSuccessState extends LegalObligationState {
  const LegalObligationPartnerRenewalSuccessState();
}

class LegalObligationPartnerRenewalErrorState extends LegalObligationState {
  final String message;

  const LegalObligationPartnerRenewalErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LegalObligationNotifyPartnerEmptyDataSendingState
    extends LegalObligationState {
  final String type;

  const LegalObligationNotifyPartnerEmptyDataSendingState(this.type);

  @override
  List<Object?> get props => [type];
}

class LegalObligationNotifyPartnerEmptyDataSuccessState
    extends LegalObligationState {
  final String type;
  final bool shouldLockButton;

  const LegalObligationNotifyPartnerEmptyDataSuccessState({
    required this.type,
    required this.shouldLockButton,
  });

  @override
  List<Object?> get props => [type, shouldLockButton];
}

class LegalObligationNotifyPartnerEmptyDataErrorState
    extends LegalObligationState {
  final String type;
  final String message;
  final bool shouldLockButton;

  const LegalObligationNotifyPartnerEmptyDataErrorState({
    required this.type,
    required this.message,
    this.shouldLockButton = false,
  });

  @override
  List<Object?> get props => [type, message, shouldLockButton];
}
