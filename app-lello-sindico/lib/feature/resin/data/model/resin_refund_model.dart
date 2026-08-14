import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_receipt_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_inconcistency.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

part 'resin_refund_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinRefundModel {
  String id;
  DateTime? requestDate;
  String requester;
  String status;
  String type;
  double value;
  String protocol;
  String? description;
  bool canEdit;
  bool canCancel;
  String inconcistency;
  List<ResinRefundReceiptModel> receipts;
  ResinBankAccountModel? destinationAccount;

  ResinRefundModel({
    this.id = "",
    this.requestDate,
    this.requester = "",
    this.status = "",
    this.type = "",
    this.value = 0.0,
    this.protocol = "",
    this.canEdit = false,
    this.canCancel = false,
    this.inconcistency = "",
    this.receipts = const [],
    this.destinationAccount,
    this.description,
  });

  factory ResinRefundModel.fromJson(Map<String, dynamic> json) =>
      _$ResinRefundModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinRefundModelToJson(this);

  static ResinRefundModel fromEntity(ResinRefund entity) => ResinRefundModel(
        id: entity.id ?? "",
        requestDate: entity.requestDate,
        requester: entity.requester,
        status: enumToString(entity.status) ?? "",
        type: enumToString(entity.type) ?? "",
        value: entity.value,
        protocol: entity.protocol,
        description: entity.description,
        canEdit: entity.canEdit,
        canCancel: entity.canCancel,
        inconcistency: enumToString(entity.inconcistency) ?? "",
        receipts: entity.receipts
            .map((e) => ResinRefundReceiptModel.fromEntity(e))
            .toList(),
        destinationAccount:
            ResinBankAccountModel.fromEntity(entity.destinationAccount),
      );

  ResinRefund? toEntity() => isValid
      ? ResinRefund(
          id: this.id,
          requestDate: this.requestDate,
          requester: this.requester,
          status: stringToEnum(ResinRefundStatus.values, this.status),
          type: stringToEnum(ResinRefundType.values, this.type),
          value: this.value,
          protocol: this.protocol,
          description: this.description,
          canEdit: this.canEdit,
          canCancel: this.canCancel,
          inconcistency:
              stringToEnum(ResinRefundInconcistency.values, this.inconcistency),
          receipts: this
              .receipts
              .map((e) => e.toEntity())
              .whereType<ResinRefundReceipt>()
              .toList(),
          destinationAccount: this.destinationAccount!.toEntity()!,
        )
      : null;

  //Verify if model isValid to convert to Entity
  bool get isValid {
    if (destinationAccount == null) {
      return false;
    }
    if (!destinationAccount!.isValid) {
      return false;
    }
    return true;
  }
}
