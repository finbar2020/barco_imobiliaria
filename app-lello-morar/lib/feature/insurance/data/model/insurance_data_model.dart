import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_data.dart';

part 'insurance_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsuranceDataModel {
  String? name;
  double? cost;
  String? idUnit;
  String? idInsurance;
  String? flagJoin;

  InsuranceDataModel({
    this.name,
    this.cost,
    this.idUnit,
    this.idInsurance,
    this.flagJoin,
  });

  factory InsuranceDataModel.fromJson(dynamic json) =>
      _$InsuranceDataModelFromJson(json);

  dynamic toJson() => _$InsuranceDataModelToJson(this);

  static InsuranceDataModel? fromEntity(InsuranceData? entity) => entity == null
      ? null
      : (InsuranceDataModel()
        ..name = entity.name
        ..cost = entity.cost
        ..idUnit = entity.idUnit
        ..idInsurance = entity.idInsurance
        ..flagJoin = entity.flagJoin);

  InsuranceData toEntity() => InsuranceData()
    ..name = this.name
    ..cost = this.cost
    ..idUnit = this.idUnit
    ..idInsurance = this.idInsurance
    ..flagJoin = this.flagJoin;
}
