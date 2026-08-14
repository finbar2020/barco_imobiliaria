import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';

part 'contas_pagar_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ContasPagarModel {
  int? installmentId;
  int? supplierId;
  int? transactionId;
  int? transactionQuantity;
  String? supplierName;
  String? supplierCnpj;
  String? documentNumber;
  String? status;
  String? statusDescription;
  String? type;
  String? sendType;
  String? releaseDate;
  String? dueDate;
  String? withdrawalDate;
  double? value;
  double? totalValue;
  String? checkNumber;
  String? typeCode;
  String? account;
  String? ledgerAccountDescription;
  String? historical;
  bool? receiptFlag;
  double? inss;
  double? csll;
  double? irrf;
  double? iss;

  ContasPagarModel();

  factory ContasPagarModel.fromJson(Map<String, dynamic> json) =>
      _$ContasPagarModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContasPagarModelToJson(this);

  static ContasPagarModel? fromEntity(ContasPagarEntity? entity) =>
      entity == null
          ? null
          : (ContasPagarModel()
            ..installmentId = entity.installmentId
            ..supplierId = entity.supplierId
            ..transactionId = entity.transactionId
            ..transactionQuantity = entity.transactionQuantity
            ..supplierName = entity.supplierName
            ..supplierCnpj = entity.supplierCnpj
            ..documentNumber = entity.documentNumber
            ..status = entity.status
            ..statusDescription = entity.statusDescription
            ..type = entity.type
            ..sendType = entity.sendType
            ..releaseDate = entity.releaseDate
            ..dueDate = entity.dueDate
            ..withdrawalDate = entity.withdrawalDate
            ..value = entity.value
            ..totalValue = entity.totalValue
            ..checkNumber = entity.checkNumber
            ..typeCode = entity.typeCode
            ..account = entity.account
            ..ledgerAccountDescription = entity.ledgerAccountDescription
            ..historical = entity.historical
            ..receiptFlag = entity.receiptFlag
            ..inss = entity.inss
            ..csll = entity.csll
            ..irrf = entity.irrf
            ..iss = entity.iss);

  ContasPagarEntity toEntity() => ContasPagarEntity(
      installmentId: installmentId,
      supplierId: supplierId,
      transactionId: transactionId,
      transactionQuantity: transactionQuantity,
      supplierName: supplierName,
      supplierCnpj: supplierCnpj,
      documentNumber: documentNumber,
      status: status,
      statusDescription: statusDescription,
      type: type,
      sendType: sendType,
      releaseDate: releaseDate,
      dueDate: dueDate,
      withdrawalDate: withdrawalDate,
      value: value,
      totalValue: totalValue,
      checkNumber: checkNumber,
      typeCode: typeCode,
      account: account,
      ledgerAccountDescription: ledgerAccountDescription,
      historical: historical,
      receiptFlag: receiptFlag,
      inss: inss,
      csll: csll,
      irrf: irrf,
      iss: iss);
}
