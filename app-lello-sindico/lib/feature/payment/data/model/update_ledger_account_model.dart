import 'package:essentials/essentials.dart';
part 'update_ledger_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateLedgerAccountModel {
  final bool? success;

  UpdateLedgerAccountModel({
    this.success,
  });

  factory UpdateLedgerAccountModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateLedgerAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateLedgerAccountModelToJson(this);

  factory UpdateLedgerAccountModel.fromEntity(bool entity) {
    return UpdateLedgerAccountModel(
      success: entity,
    );
  }

  bool toEntity() {
    return success ?? false;
  }
}
