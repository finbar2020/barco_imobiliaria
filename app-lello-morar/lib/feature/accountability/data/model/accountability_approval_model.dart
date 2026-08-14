import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/accountability/data/model/accountability_model.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_approval.dart';

part 'accountability_approval_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityApprovalModel {
  String? id;
  AccountabilityModel? accountability;
  DateTime? date;

  AccountabilityApprovalModel();

  factory AccountabilityApprovalModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityApprovalModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountabilityApprovalModelToJson(this);

  static AccountabilityApprovalModel? fromEntity(
          AccountabilityApproval? entity) =>
      entity == null
          ? null
          : (AccountabilityApprovalModel()
            ..accountability =
                AccountabilityModel.fromEntity(entity.accountability)
            ..date = entity.date
            ..id = entity.id);

  AccountabilityApproval toEntity() => AccountabilityApproval()
    ..accountability = this.accountability?.toEntity()
    ..date = this.date
    ..id = this.id;
}
