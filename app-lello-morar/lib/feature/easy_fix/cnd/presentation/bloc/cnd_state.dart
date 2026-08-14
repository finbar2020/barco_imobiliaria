import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

abstract class CertificateNoOutstandingDebtState extends Equatable {
  const CertificateNoOutstandingDebtState();

  @override
  List<Object?> get props => [];
}

class UnitProfileLoadingState extends CertificateNoOutstandingDebtState {
  const UnitProfileLoadingState();
}

class UnitProfileFailureState extends CertificateNoOutstandingDebtState {
  final Failure? failure;

  const UnitProfileFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UnitProfileLoadedState extends CertificateNoOutstandingDebtState {
  final EasyFixUnit unit;

  const UnitProfileLoadedState({required this.unit});

  @override
  List<Object?> get props => [unit];
}

class CertificateNoOutstandingDebtInitialState
    extends CertificateNoOutstandingDebtState {
  const CertificateNoOutstandingDebtInitialState();
}

class CertificateNoOutstandingDebtLoadingState
    extends CertificateNoOutstandingDebtState {
  const CertificateNoOutstandingDebtLoadingState();
}

class CertificateNoOutstandingDebtFailureState
    extends CertificateNoOutstandingDebtState {
  final Failure? failure;

  const CertificateNoOutstandingDebtFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class CertificateNoOutstandingDebtSucessState
    extends CertificateNoOutstandingDebtState {
  final String pdf;

  const CertificateNoOutstandingDebtSucessState({required this.pdf});

  @override
  List<Object?> get props => [pdf];
}

class HasOutstandingDebtState extends CertificateNoOutstandingDebtState {
  const HasOutstandingDebtState();
}
