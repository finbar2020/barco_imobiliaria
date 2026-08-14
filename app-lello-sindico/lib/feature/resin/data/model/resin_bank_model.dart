import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';

part 'resin_bank_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinBankModel {
  String id;
  String bankCode;
  String bankName;

  ResinBankModel({
    this.id = "",
    this.bankCode = "",
    this.bankName = "",
  });

  factory ResinBankModel.fromJson(Map<String, dynamic> json) =>
      _$ResinBankModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinBankModelToJson(this);

  static ResinBankModel? fromEntity(ResinBank? entity) => entity == null
      ? null
      : (ResinBankModel(
          id: entity.id,
          bankCode: entity.bankCode,
          bankName: entity.bankName,
        ));

  ResinBank? toEntity() => this.isValid
      ? ResinBank(
          id: id,
          bankCode: bankCode,
          bankName: bankName,
        )
      : null;

  bool get isValid {
    if (id.isEmpty) {
      return false;
    }
    if (bankCode.isEmpty) {
      return false;
    }
    if (bankName.isEmpty) {
      return false;
    }
    return true;
  }
}
