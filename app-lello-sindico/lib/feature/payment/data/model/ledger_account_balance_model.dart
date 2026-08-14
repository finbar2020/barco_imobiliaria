import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account_balance.dart';
part 'ledger_account_balance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LedgerAccountBalanceModel {
  final double balance;

  LedgerAccountBalanceModel({
    required this.balance,
  });

  factory LedgerAccountBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LedgerAccountBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerAccountBalanceModelToJson(this);

  static LedgerAccountBalanceModel? fromEntity(LedgerAccountBalance? entity) {
    if (entity == null) return null;
    return LedgerAccountBalanceModel(
      balance: entity.balance,
    );
  }

  LedgerAccountBalance toEntity() {
    return LedgerAccountBalance(
      balance: balance,
    );
  }
}
