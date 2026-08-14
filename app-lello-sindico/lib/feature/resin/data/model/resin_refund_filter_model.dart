import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_inconcistency.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

part 'resin_refund_filter_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinRefundFilterModel {
  DateTime? startDate;
  DateTime? endDate;
  String? protocol;
  String? status;
  String? inconsistency;
  String? type;

  ResinRefundFilterModel({
    this.startDate,
    this.endDate,
    this.protocol,
    this.status,
    this.inconsistency,
    this.type,
  });

  factory ResinRefundFilterModel.fromJson(Map<String, dynamic> json) =>
      _$ResinRefundFilterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinRefundFilterModelToJson(this);

  static ResinRefundFilterModel fromEntity(ResinRefundFilter entity) =>
      ResinRefundFilterModel(
        startDate: entity.startDate,
        endDate: entity.endDate,
        protocol: entity.protocol,
        status: enumToString(entity.status),
        inconsistency: enumToString(entity.inconsistency),
        type: enumToString(entity.type),
      );

  ResinRefundFilter toEntity() => ResinRefundFilter(
        startDate: this.startDate,
        endDate: this.endDate,
        protocol: this.protocol,
        status: stringToEnum(ResinRefundStatus.values, this.status ?? ''),
        inconsistency: stringToEnum(
            ResinRefundInconcistency.values, this.inconsistency ?? ''),
        type: stringToEnum(ResinRefundType.values, this.type ?? ''),
      );
}
