import 'package:essentials/essentials.dart';

part 'update_non_manager_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateNonManagerUserModel {
  final String id;

  final bool isActive;
  UpdateNonManagerUserModel({
    required this.id,
    required this.isActive,
  });

  factory UpdateNonManagerUserModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateNonManagerUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNonManagerUserModelToJson(this);
}
