import 'package:essentials/essentials.dart';
part 'check_approval_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CheckApprovalProfileModel {
  final bool? success;

  CheckApprovalProfileModel({
    this.success,
  });

  factory CheckApprovalProfileModel.fromJson(Map<String, dynamic> json) =>
      _$CheckApprovalProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckApprovalProfileModelToJson(this);

  factory CheckApprovalProfileModel.fromEntity(bool entity) {
    return CheckApprovalProfileModel(
      success: entity,
    );
  }

  bool toEntity() {
    return success ?? false;
  }
}
