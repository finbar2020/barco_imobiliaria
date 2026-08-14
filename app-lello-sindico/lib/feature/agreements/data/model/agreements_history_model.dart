import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_history.dart';

part 'agreements_history_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsHistoryModel {
  List<AgreementModel> agreements;

  AgreementsHistoryModel({
    required this.agreements,
  });

  factory AgreementsHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsHistoryModelToJson(this);

  static AgreementsHistoryModel? fromEntity(AgreementsHistory? entity) =>
      entity == null
          ? null
          : (AgreementsHistoryModel(
              agreements: entity.agreements
                  .map((agreement) => AgreementModel.fromEntity(agreement)!)
                  .toList()));
  AgreementsHistory toEntity() => AgreementsHistory(
        agreements:
            this.agreements.map((agreement) => agreement.toEntity()).toList(),
      );
}
