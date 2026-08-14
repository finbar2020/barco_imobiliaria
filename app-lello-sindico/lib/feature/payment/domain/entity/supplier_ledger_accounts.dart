import 'package:lello/feature/payment/domain/entity/ledger_account.dart';

class SupplierLedgerAccountsEntity {
  final LedgerAccountEntity? recomendation;
  final List<LedgerAccountEntity?> ordinary;
  final List<LedgerAccountEntity?> extraordinary;
  final List<LedgerAccountEntity?> all;

  SupplierLedgerAccountsEntity({
    this.recomendation,
    this.ordinary = const [],
    this.extraordinary = const [],
    this.all = const [],
  });

  SupplierLedgerAccountsEntity copyWith({
    LedgerAccountEntity? recomendation,
    List<LedgerAccountEntity>? ordinary,
    List<LedgerAccountEntity>? extraordinary,
    List<LedgerAccountEntity>? all,
  }) {
    return SupplierLedgerAccountsEntity(
      recomendation: recomendation ?? this.recomendation,
      ordinary: ordinary ?? this.ordinary,
      extraordinary: extraordinary ?? this.extraordinary,
      all: all ?? this.all,
    );
  }
}
