import 'package:essentials/essentials.dart';
part 'update_installment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateInstallmentModel {
  final bool? success;

  UpdateInstallmentModel({
    this.success,
  });

  factory UpdateInstallmentModel.fromJson(Map<String, dynamic> json) {
    final model = _$UpdateInstallmentModelFromJson(json);
    return model;
  }

  Map<String, dynamic> toJson() => _$UpdateInstallmentModelToJson(this);

  factory UpdateInstallmentModel.fromEntity(bool entity) {
    return UpdateInstallmentModel(
      success: entity,
    );
  }

  bool toEntity() {
    final result = success ?? false;
    return result;
  }
}
