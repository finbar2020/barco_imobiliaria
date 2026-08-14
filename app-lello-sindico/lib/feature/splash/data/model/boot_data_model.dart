import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';

part 'boot_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BootDataModel {
  bool? showOnBoarding;
  BootDataModel();

  factory BootDataModel.fromJson(Map<String, dynamic> json) =>
      _$BootDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$BootDataModelToJson(this);

  static BootDataModel? fromEntity(BootData? entity) => entity == null
      ? null
      : (BootDataModel()..showOnBoarding = entity.showOnBoarding);

  BootData toEntity() =>
      BootData()..showOnBoarding = this.showOnBoarding == true;
}
