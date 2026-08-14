import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item_status.dart';

part 'payment_history_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentHistoryItemModel {
  int? documentId;
  String? fileName;
  String? releaseId;
  String? reference;
  String? processingStatus;
  DateTime? inclusionDate;
  double? totalValue;
  String? supplierName;
  int? installments;
  String? documentOrigin;

  PaymentHistoryItemModel();

  // Factory para deserialização do JSON
  factory PaymentHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryItemModelFromJson(json);

  // Método para serializar para JSON
  Map<String, dynamic> toJson() => _$PaymentHistoryItemModelToJson(this);

  // Conversão de entidade para modelo
  static PaymentHistoryItemModel? fromEntity(PaymentHistoryItem? entity) =>
      entity == null
          ? null
          : (PaymentHistoryItemModel()
            ..documentId = entity.documentId
            ..fileName = entity.fileName
            ..releaseId = entity.releaseId
            ..reference = entity.reference
            ..processingStatus = enumToString(entity.processingStatus)
            ..inclusionDate = entity.inclusionDate
            ..totalValue = entity.totalValue?.toDouble()
            ..supplierName = entity.supplierName
            ..installments = entity.installments
            ..documentOrigin = entity.documentOrigin);

  // Conversão de modelo para entidade
  PaymentHistoryItem toEntity() => PaymentHistoryItem(
        documentId: documentId ?? 0,
        fileName: fileName,
        releaseId: releaseId,
        reference: reference,
        processingStatus: stringToEnum(
              PaymentHistoryItemStatus.values,
              processingStatus!,
            ) ??
            PaymentHistoryItemStatus.progress,
        inclusionDate: inclusionDate,
        totalValue: totalValue,
        supplierName: supplierName,
        installments: installments,
        documentOrigin: documentOrigin,
      );
}
