import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

abstract class CertificateNoOutstandingDebtEvent extends Equatable {
  const CertificateNoOutstandingDebtEvent();

  @override
  List<Object?> get props => [];
}

class UnitProfileLoadingEvent extends CertificateNoOutstandingDebtEvent {
  const UnitProfileLoadingEvent();
}

class UnitProfileFailureEvent extends CertificateNoOutstandingDebtEvent {
  final Failure? failure;

  const UnitProfileFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UnitProfileLoadedEvent extends CertificateNoOutstandingDebtEvent {
  final EasyFixUnit unit;

  const UnitProfileLoadedEvent({required this.unit});

  @override
  List<Object?> get props => [unit];
}

class CertificateNoOutstandingDebtEmptyEvent
    extends CertificateNoOutstandingDebtEvent {
  const CertificateNoOutstandingDebtEmptyEvent();
}

class CertificateNoOutstandingDebtLoadingEvent
    extends CertificateNoOutstandingDebtEvent {
  const CertificateNoOutstandingDebtLoadingEvent();
}

class CertificateNoOutstandingDebtFailureEvent
    extends CertificateNoOutstandingDebtEvent {
  final Failure? failure;

  const CertificateNoOutstandingDebtFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class CertificateNoOutstandingDebtSucessEvent
    extends CertificateNoOutstandingDebtEvent {
  final String pdf;

  const CertificateNoOutstandingDebtSucessEvent({required this.pdf});

  @override
  List<Object?> get props => [pdf];
}

class HasOutstandingDebtEvent extends CertificateNoOutstandingDebtEvent {
  const HasOutstandingDebtEvent();
}
