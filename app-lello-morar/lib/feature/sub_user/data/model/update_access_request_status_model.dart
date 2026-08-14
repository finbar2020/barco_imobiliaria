import 'package:essentials/essentials.dart';

part 'update_access_request_status_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UpdateAccessRequestStatusModel {

  final int? id;
  final String? status;
  final DateTime? expiresAt;

  UpdateAccessRequestStatusModel({
    this.id,
    this.status,
    this.expiresAt,
  });

  factory UpdateAccessRequestStatusModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccessRequestStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAccessRequestStatusModelToJson(this);

}