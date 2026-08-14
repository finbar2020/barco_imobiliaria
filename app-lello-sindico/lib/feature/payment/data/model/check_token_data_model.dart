import 'package:essentials/essentials.dart';
part 'check_token_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CheckTokenDataModel {
  final bool? success;

  CheckTokenDataModel({
    this.success,
  });

  factory CheckTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$CheckTokenDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckTokenDataModelToJson(this);

  factory CheckTokenDataModel.fromEntity(bool entity) {
    return CheckTokenDataModel(
      success: entity,
    );
  }

  bool toEntity() {
    return success ?? false;
  }
}
