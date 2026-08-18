import 'package:cross_file/cross_file.dart';

import '../enums/legal_obligation_tab.dart';
import '../../../domain/entity/legal_obligation_entity.dart';

abstract class LegalObligationState {
  const LegalObligationState();
}

class LegalObligationIdleState extends LegalObligationState {
  const LegalObligationIdleState();
}

class LegalObligationLoadingState extends LegalObligationState {
  final LegalObligationTab tab;

  const LegalObligationLoadingState(this.tab);
}

class LegalObligationLoadedState extends LegalObligationState {
  final LegalObligationTab tab;
  final LegalObligationEntity data;

  const LegalObligationLoadedState(this.tab, this.data);
}

class LegalObligationErrorState extends LegalObligationState {
  final String message;

  const LegalObligationErrorState(this.message);
}

class LegalObligationDownloadingFileState extends LegalObligationState {
  const LegalObligationDownloadingFileState();
}

class LegalObligationDownloadSuccessState extends LegalObligationState {
  final XFile file;

  const LegalObligationDownloadSuccessState(this.file);
}

class LegalObligationDownloadErrorState extends LegalObligationState {
  final String message;

  const LegalObligationDownloadErrorState(this.message);
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
}

class LegalObligationNotifyPartnerEmptyDataSendingState
    extends LegalObligationState {
  final String type;

  const LegalObligationNotifyPartnerEmptyDataSendingState(this.type);
}

class LegalObligationNotifyPartnerEmptyDataSuccessState
    extends LegalObligationState {
  final String type;
  final bool shouldLockButton;

  const LegalObligationNotifyPartnerEmptyDataSuccessState({
    required this.type,
    required this.shouldLockButton,
  });
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
}
