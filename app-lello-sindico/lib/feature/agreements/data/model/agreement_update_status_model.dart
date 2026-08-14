import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_update_status.dart';

part 'agreement_update_status_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementUpdateStatusModel {
  String userName;
  String agreementId;
  bool approved;
  String? reason;

  AgreementUpdateStatusModel({
    required this.userName,
    required this.agreementId,
    required this.approved,
    this.reason,
  });

  factory AgreementUpdateStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementUpdateStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementUpdateStatusModelToJson(this);

  static AgreementUpdateStatusModel? fromEntity(
          AgreementUpdateStatus? entity) =>
      entity == null
          ? null
          : AgreementUpdateStatusModel(
              userName: entity.userName,
              agreementId: entity.agreementId,
              approved: entity.approved,
              reason: entity.reason,
            );

  AgreementUpdateStatus toEntity() => AgreementUpdateStatus(
        userName: this.userName,
        agreementId: this.agreementId,
        approved: this.approved,
        reason: this.reason,
      );
}
