import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/data/model/resin_refund_digital_document_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_digital_document.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';

part 'resin_refund_receipt_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinRefundReceiptModel {
  String? id;
  ResinRefundDigitalDocumentModel? digitalDocument;
  DateTime? sendDate;
  double? receiptValue;
  String? receiptType;

  ResinRefundReceiptModel({
    this.id,
    this.digitalDocument,
    this.sendDate,
    this.receiptValue,
    this.receiptType,
  });

  factory ResinRefundReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ResinRefundReceiptModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinRefundReceiptModelToJson(this);

  static ResinRefundReceiptModel fromEntity(ResinRefundReceipt entity) =>
      ResinRefundReceiptModel(
        id: entity.id,
        digitalDocument: entity.digitalDocument == null
            ? null
            : ResinRefundDigitalDocumentModel.fromEntity(
                entity.digitalDocument!),
        sendDate: entity.sendDate,
        receiptValue: entity.receiptValue,
        receiptType: enumToString(entity.receiptType),
      );

  ResinRefundReceipt? toEntity() => isValid
      ? ResinRefundReceipt(
          id: this.id,
          digitalDocument: this.digitalDocument!.toEntity() ??
              ResinRefundDigitalDocument(
                id: '',
                bytes: '',
                name: '',
              ),
          sendDate: this.sendDate,
          receiptValue: this.receiptValue!,
          receiptType: stringToEnum(
              ResinRefundReceiptType.values, this.receiptType ?? ""),
        )
      : null;

  //Verify if model isValid to convert to Entity
  bool get isValid {
    if (id == null) {
      return false;
    }
    if (digitalDocument == null) {
      return false;
    }
    if (!digitalDocument!.isValid) {
      return false;
    }
    if (receiptValue == null) {
      return false;
    }
    return true;
  }
}
