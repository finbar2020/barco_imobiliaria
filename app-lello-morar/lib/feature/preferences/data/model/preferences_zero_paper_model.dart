import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_enum.dart';

part 'preferences_zero_paper_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PreferencesZeroPaperModel {
  PreferencesZeroPaperEnum? deliveryAnnouncements;
  PreferencesZeroPaperEnum? deliveryActs;
  PreferencesZeroPaperEnum? deliverySlips;
  PreferencesZeroPaperEnum? deliveryStatements;
  bool? allUnits;

  PreferencesZeroPaperModel({
    this.deliveryAnnouncements,
    this.deliveryActs,
    this.deliverySlips,
    this.deliveryStatements,
    this.allUnits,
  });

  factory PreferencesZeroPaperModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesZeroPaperModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesZeroPaperModelToJson(this);

  static PreferencesZeroPaperModel? fromEntity(
          PreferencesZeroPaperEntity? entity) =>
      entity == null
          ? null
          : (PreferencesZeroPaperModel()
            ..deliveryAnnouncements = stringToEnum(
                    PreferencesZeroPaperEnum.values,
                    entity.deliveryAnnouncements) ??
                PreferencesZeroPaperEnum.digital
            ..deliveryActs = stringToEnum(
                    PreferencesZeroPaperEnum.values, entity.deliveryActs) ??
                PreferencesZeroPaperEnum.digital
            ..deliverySlips = stringToEnum(
                    PreferencesZeroPaperEnum.values, entity.deliverySlips) ??
                PreferencesZeroPaperEnum.digital
            ..deliveryStatements = stringToEnum(PreferencesZeroPaperEnum.values,
                    entity.deliveryStatements) ??
                PreferencesZeroPaperEnum.digital
            ..allUnits = entity.allUnits);

  PreferencesZeroPaperEntity toEntity() => PreferencesZeroPaperEntity()
    ..deliveryAnnouncements = enumToString(this.deliveryAnnouncements)
    ..deliveryActs = enumToString(this.deliveryActs)
    ..deliverySlips = enumToString(this.deliverySlips)
    ..deliveryStatements = enumToString(this.deliveryStatements)
    ..allUnits = this.allUnits ?? false;
}
