import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/resin_params.dart';

part 'resin_params_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinParamsModel {
  double avaliableValue;
  double requestMaxValue;
  double refundMaxValue;
  double refundTotalValue;
  int? requestOnPeriod;
  int? pendingRequests;

  double? maxFileSizeAllowed;

  DateTime? filterStartDate;
  DateTime? filterEndDate;

  ResinParamsModel({
    this.avaliableValue = 0.0,
    this.requestMaxValue = 0.0,
    this.refundMaxValue = 0.0,
    this.refundTotalValue = 0.0,
    this.requestOnPeriod,
    this.pendingRequests,
    this.maxFileSizeAllowed,
    this.filterStartDate,
    this.filterEndDate,
  });

  factory ResinParamsModel.fromJson(Map<String, dynamic> json) =>
      _$ResinParamsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinParamsModelToJson(this);

  static ResinParamsModel? fromEntity(ResinParams? entity) => entity == null
      ? null
      : (ResinParamsModel(
          avaliableValue: entity.avaliableValue,
          requestMaxValue: entity.requestMaxValue,
          maxFileSizeAllowed: entity.maxFileSizeAllowed,
          refundMaxValue: entity.refundMaxValue,
          refundTotalValue: entity.refundTotalValue,
          requestOnPeriod: entity.requestOnPeriod,
          pendingRequests: entity.pendingRequests,
          filterStartDate: entity.filterStartDate,
          filterEndDate: entity.filterEndDate,
        ));

  ResinParams toEntity() => ResinParams(
        avaliableValue: this.avaliableValue,
        requestMaxValue: this.requestMaxValue,
        maxFileSizeAllowed: this.maxFileSizeAllowed,
        refundMaxValue: this.refundMaxValue,
        refundTotalValue: this.refundTotalValue,
        requestOnPeriod: this.requestOnPeriod,
        pendingRequests: this.pendingRequests,
        filterStartDate: this.filterStartDate,
        filterEndDate: this.filterEndDate,
      );
}
