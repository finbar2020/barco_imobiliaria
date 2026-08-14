import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/insurance/data/model/insurance_data_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_info_model.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';

part 'insurance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsuranceModel {
  InsuranceDataModel? insuranceData;
  String? insuranceStatus;
  InsuranceInfoModel? insuranceInfo;

  InsuranceModel({
    this.insuranceData,
    this.insuranceStatus,
    this.insuranceInfo,
  });

  factory InsuranceModel.fromJson(dynamic json) =>
      _$InsuranceModelFromJson(json);

  dynamic toJson() => _$InsuranceModelToJson(this);

  static InsuranceModel? fromEntity(Insurance? entity) => entity == null
      ? null
      : (InsuranceModel()
        ..insuranceData = InsuranceDataModel.fromEntity(entity.insuranceData)
        ..insuranceStatus = entity.insuranceStatus
        ..insuranceInfo = InsuranceInfoModel.fromEntity(entity.insuranceInfo));

  Insurance toEntity() => Insurance()
    ..insuranceData = this.insuranceData?.toEntity()
    ..insuranceStatus = this.insuranceStatus
    ..insuranceInfo = this.insuranceInfo?.toEntity();
}
