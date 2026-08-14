import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';

enum PendingRequestStatus {
  pendingOwner,
}

enum RegistrationOrigin {
  lelloRegistration,
  conciergeRegistration,
  registrationWithoutContract,
  changeOfOwnership,
}

extension RegistrationOriginExtension on RegistrationOrigin {
  String get name {
    switch (this) {
      case RegistrationOrigin.lelloRegistration:
        return S.current.registrationLello;
      case RegistrationOrigin.conciergeRegistration:
        return S.current.conciergeRegistration;
      case RegistrationOrigin.registrationWithoutContract:
        return S.current.registrationWithoutContract;
      case RegistrationOrigin.changeOfOwnership:
        return S.current.changeOfOwnership;
    }
  }

  String get value {
    switch (this) {
      case RegistrationOrigin.lelloRegistration:
        return 'LELLO';
      case RegistrationOrigin.conciergeRegistration:
        return 'PORTARIA';
      case RegistrationOrigin.registrationWithoutContract:
        return 'RESOLVA_FACIL_SEM_CONTRATO';
      case RegistrationOrigin.changeOfOwnership:
        return 'JOB_ALTERACAO_TITULARIDADE';
    }
  }

  Color color(ThemeData theme) {
    switch (this) {
      case RegistrationOrigin.lelloRegistration:
        return LelloTheme.palleteOf(theme).primary();
      case RegistrationOrigin.conciergeRegistration:
        return Color(0xFF0058A0);
      case RegistrationOrigin.registrationWithoutContract:
        return LelloTheme.palleteOf(theme).warning();
      case RegistrationOrigin.changeOfOwnership:
        return Color(0xFF8D3393);
    }
  }
}
