import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_request_attachments_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_grouped_account_entrie_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';

part 'acountability_doubt_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityDoubtRequestModel {
  String message;
  List<AttachmentsRequestModel> attachments;
  DateTime period;
  String typeId;
  List<AccountabilityGroupedAccaountEntrieModel> enteries;

  AccountabilityDoubtRequestModel({
    required this.message,
    required this.attachments,
    required this.period,
    required this.typeId,
    required this.enteries,
  });

  factory AccountabilityDoubtRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityDoubtRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityDoubtRequestModelToJson(this);

  static AccountabilityDoubtRequestModel fromEntity(
          AccountabilityDoubt entity) =>
      (AccountabilityDoubtRequestModel(
          message: entity.message,
          period: entity.period,
          attachments: entity.attachmentsFiles
              .map((e) => AttachmentsRequestModel.fromEntity(e))
              .toList(),
          enteries: entity.entiries
              .map(
                  (e) => AccountabilityGroupedAccaountEntrieModel.fromEntity(e))
              .toList(),
          typeId: entity.doubtType!.id));
}
