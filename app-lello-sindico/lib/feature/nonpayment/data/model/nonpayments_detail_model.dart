// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/nonpayment/data/model/nonpayments_receipts_model.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';

part 'nonpayments_detail_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NonPaymentsDetailModel {
  final DateTime? period;
  final double? valueLiquid;
  final double? interest;
  final double? penalty;
  final double? value;
  final ResidentModel? resident;
  final List<NonPaymentsReceiptsModel?>? receipts;

  NonPaymentsDetailModel({
    this.period,
    this.valueLiquid,
    this.interest,
    this.penalty,
    this.value,
    this.resident,
    this.receipts,
  });

  factory NonPaymentsDetailModel.fromJson(Map<String, dynamic> json) =>
      _$NonPaymentsDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$NonPaymentsDetailModelToJson(this);

  static NonPaymentsDetailModel? fromEntity(NonPaymentsDetail? entity) =>
      entity == null
          ? null
          : (NonPaymentsDetailModel(
              valueLiquid: entity.valueLiquid,
              period: entity.period,
              interest: entity.interest,
              penalty: entity.penalty,
              value: entity.value,
              resident: ResidentModel.fromEntity(entity.resident),
              receipts: entity.receipts
                      ?.map((entity) =>
                          NonPaymentsReceiptsModel.fromEntity(entity))
                      .toList() ??
                  [],
            ));

  NonPaymentsDetail toEntity() {
    return NonPaymentsDetail(
      valueLiquid: valueLiquid,
      period: period,
      interest: interest,
      penalty: penalty,
      value: value,
      resident: resident?.toEntity(),
      receipts: receipts?.map((model) => model?.toEntity()).toList() ?? [],
    );
  }

  NonPaymentsDetailModel copyWith({
    DateTime? period,
    double? valueLiquid,
    double? interest,
    double? penalty,
    double? value,
    ResidentModel? resident,
    List<NonPaymentsReceiptsModel?>? receipts,
  }) {
    return NonPaymentsDetailModel(
      period: period ?? this.period,
      valueLiquid: valueLiquid ?? this.valueLiquid,
      interest: interest ?? this.interest,
      penalty: penalty ?? this.penalty,
      value: value ?? this.value,
      resident: resident ?? this.resident,
      receipts: receipts ?? this.receipts,
    );
  }
}
