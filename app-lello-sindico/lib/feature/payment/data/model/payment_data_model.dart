import 'package:essentials/enum/enum_serializer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/installment_model.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_document_type.dart';

part 'payment_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentDataModel {
  final int? idSupplier;
  final String? documentSupplier;
  final int? idContract;
  final String? documentNumber;
  final String? documentType;
  final DateTime? dueDate;
  final int? installmentQuantity;
  final double? totalValue;
  final String? observation;
  final String? filePathLaunch;
  final int? totalPages;
  final int? ledgerAccount;
  final bool? isUtilityAccount;
  final bool? isSendFinancial;
  final List<InstallmentModel?>? installments;

  PaymentDataModel({
    this.idSupplier,
    this.documentSupplier,
    this.idContract,
    this.documentNumber,
    this.documentType,
    this.dueDate,
    this.installmentQuantity,
    this.totalValue,
    this.observation,
    this.filePathLaunch,
    this.totalPages,
    this.ledgerAccount,
    this.isUtilityAccount,
    this.isSendFinancial = false,
    this.installments = const [],
  });

  factory PaymentDataModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDataModelToJson(this);

  static PaymentDataModel? fromEntity(PaymentDataEntity? entity) {
    if (entity == null) return null;
    return PaymentDataModel(
      idSupplier: entity.idSupplier,
      documentSupplier: entity.documentSupplier,
      idContract: entity.idContract,
      documentNumber: entity.documentNumber,
      documentType: enumToString(entity.documentType),
      dueDate: entity.dueDate,
      installmentQuantity: entity.installmentQuantity,
      totalValue: entity.totalValue,
      observation: entity.observation,
      filePathLaunch: entity.filePathLaunch,
      totalPages: entity.totalPages,
      ledgerAccount: entity.ledgerAccount,
      isUtilityAccount: entity.isUtilityAccount,
      isSendFinancial: entity.isSendFinancial,
      installments: entity.installments
          ?.map(InstallmentModel.fromEntity)
          .where((e) => e != null)
          .map((e) => e!)
          .toList(),
    );
  }

  PaymentDataEntity toEntity() {
    return PaymentDataEntity(
      idSupplier: idSupplier,
      documentSupplier: documentSupplier,
      idContract: idContract,
      documentNumber: documentNumber,
      documentType: stringToEnum(PaymentDocumentType.values, documentType),
      dueDate: dueDate,
      installmentQuantity: installmentQuantity,
      totalValue: totalValue,
      observation: observation,
      filePathLaunch: filePathLaunch,
      totalPages: totalPages,
      ledgerAccount: ledgerAccount,
      isUtilityAccount: isUtilityAccount,
      isSendFinancial: isSendFinancial,
      installments: installments?.isNotEmpty ?? false
          ? installments!
              .where((e) => e != null)
              .map((e) => e!)
              .map((installment) => installment.toEntity())
              .toList()
          : [],
    );
  }
}
