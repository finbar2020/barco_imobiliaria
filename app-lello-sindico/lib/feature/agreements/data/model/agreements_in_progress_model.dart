import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_in_progress.dart';

part 'agreements_in_progress_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsInProgressModel {
  List<AgreementModel> agreements;

  AgreementsInProgressModel({
    required this.agreements,
  });

  factory AgreementsInProgressModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsInProgressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsInProgressModelToJson(this);

  static AgreementsInProgressModel? fromEntity(AgreementsInProgress? entity) =>
      entity == null
          ? null
          : (AgreementsInProgressModel(
              agreements: entity.agreements
                  .map((agreement) => AgreementModel.fromEntity(agreement)!)
                  .toList()));
  AgreementsInProgress toEntity() => AgreementsInProgress(
        agreements:
            this.agreements.map((agreement) => agreement.toEntity()).toList(),
      );
}
