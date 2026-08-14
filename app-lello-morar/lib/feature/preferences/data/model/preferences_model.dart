import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/preferences/data/model/preferences_zero_paper_model.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_entity.dart';

part 'preferences_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PreferencesModel {
  PreferencesZeroPaperModel? zeroPaper;

  PreferencesModel({
    this.zeroPaper,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesModelToJson(this);

  static PreferencesModel? fromEntity(PreferencesEntity? entity) => entity ==
          null
      ? null
      : (PreferencesModel()
        ..zeroPaper = PreferencesZeroPaperModel.fromEntity(entity.zeroPaper));

  PreferencesEntity toEntity() =>
      PreferencesEntity()..zeroPaper = this.zeroPaper?.toEntity();
}
