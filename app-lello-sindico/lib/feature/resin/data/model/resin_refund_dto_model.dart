import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/data/model/resin_refund_receipt_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_dto.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

part 'resin_refund_dto_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinRefundDTOModel {
  String? id;
  double value;
  List<ResinRefundReceiptModel> receipts;
  String? description;
  String status;
  String type;
  String accountId;
  String requesterId;
  DateTime? requestDate;

  ResinRefundDTOModel({
    this.id,
    required this.value,
    required this.receipts,
    required this.status,
    required this.type,
    required this.accountId,
    required this.requesterId,
    required this.requestDate,
    this.description,
  });

  factory ResinRefundDTOModel.fromJson(Map<String, dynamic> json) =>
      _$ResinRefundDTOModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinRefundDTOModelToJson(this);

  static ResinRefundDTOModel fromResinRefundEntity(ResinRefund entity) =>
      ResinRefundDTOModel(
          id: entity.id,
          value: entity.value,
          receipts: entity.receipts
              .map((e) => ResinRefundReceiptModel.fromEntity(e))
              .toList(),
          description: entity.description,
          status: enumToString(entity.status) ?? "",
          type: enumToString(entity.type) ?? "",
          accountId: entity.destinationAccount?.id ?? "",
          requestDate: entity.requestDate,
          requesterId: entity.requesterId ?? "");

  static ResinRefundDTOModel fromEntity(ResinRefundDTO entity) =>
      ResinRefundDTOModel(
          id: entity.id,
          value: entity.value,
          receipts: entity.receipts
              .map((e) => ResinRefundReceiptModel.fromEntity(e))
              .toList(),
          description: entity.description,
          status: enumToString(entity.status) ?? "",
          type: enumToString(entity.type) ?? "",
          accountId: entity.accountId,
          requestDate: entity.requestDate,
          requesterId: entity.requesterId);

  ResinRefundDTO toEntity() => ResinRefundDTO(
        id: this.id,
        value: this.value,
        receipts: this
            .receipts
            .map((e) => e.toEntity())
            .whereType<ResinRefundReceipt>()
            .toList(),
        description: this.description,
        status: stringToEnum(ResinRefundStatus.values, this.status) ??
            ResinRefundStatus.sended,
        type: stringToEnum(ResinRefundType.values, this.type) ??
            ResinRefundType.advance,
        accountId: this.accountId,
        requestDate: this.requestDate,
        requesterId: this.requesterId,
      );
}
