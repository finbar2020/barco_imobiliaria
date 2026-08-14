import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
part 'ledger_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LedgerAccountModel {
  final int? id;
  final int? shortCode;
  final String? name;

  LedgerAccountModel({
    required this.id,
    required this.shortCode,
    required this.name,
  });

  factory LedgerAccountModel.fromJson(Map<String, dynamic> json) =>
      _$LedgerAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerAccountModelToJson(this);

  static LedgerAccountModel? fromEntity(LedgerAccountEntity? entity) {
    if (entity == null) return null;
    return LedgerAccountModel(
      id: entity.id,
      shortCode: entity.shortCode,
      name: entity.name,
    );
  }

  LedgerAccountEntity toEntity() {
    return LedgerAccountEntity(
      id: id,
      shortCode: shortCode,
      name: name,
    );
  }
}
