import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/data/model/resin_bank_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';

part 'resin_bank_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinBankAccountModel {
  String id;
  ResinBankModel? bank;
  String agency;
  String accountNumber;
  String document;
  String supplierName;
  String type;

  ResinBankAccountModel({
    this.id = "",
    this.bank,
    this.agency = "",
    this.accountNumber = "",
    this.document = "",
    this.supplierName = "",
    this.type = "",
  });

  factory ResinBankAccountModel.fromJson(Map<String, dynamic> json) =>
      _$ResinBankAccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinBankAccountModelToJson(this);

  static ResinBankAccountModel? fromEntity(ResinBankAccount? entity) =>
      entity == null
          ? null
          : (ResinBankAccountModel(
              id: entity.id,
              bank: ResinBankModel.fromEntity(entity.bank),
              agency: entity.agency,
              accountNumber: entity.accountNumber,
              document: entity.document,
              supplierName: entity.supplierName,
              type: enumToString(entity.accountType) ?? "",
            ));

  ResinBankAccount? toEntity() => this.isValid
      ? ResinBankAccount(
          id: this.id,
          bank: this.bank!.toEntity(),
          agency: this.agency,
          accountNumber: this.accountNumber,
          document: this.document,
          supplierName: this.supplierName,
          accountType: stringToEnum(ResinBankAccountType.values, this.type) ??
              ResinBankAccountType.other,
        )
      : null;

  bool get isValid {
    if (id.isEmpty) {
      return false;
    }
    if (bank == null) {
      return false;
    }
    if (agency.isEmpty) {
      return false;
    }
    if (accountNumber.isEmpty) {
      return false;
    }
    if (document.isEmpty) {
      return false;
    }
    if (supplierName.isEmpty) {
      return false;
    }
    if (type.isEmpty) {
      return false;
    }

    return true;
  }
}
