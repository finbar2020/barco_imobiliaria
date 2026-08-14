import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_recommendations.dart';

part 'accountability_recommendations_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityRecommendationsModel {
  String? name;
  String? date;
  bool? isUser;

  AccountabilityRecommendationsModel();

  factory AccountabilityRecommendationsModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccountabilityRecommendationsModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityRecommendationsModelToJson(this);

  static AccountabilityRecommendationsModel fromEntity(
          AccountabilityRecommendations entity) =>
      (AccountabilityRecommendationsModel()
        ..name = entity.name
        ..date = entity.date
        ..isUser = entity.isUser);

  AccountabilityRecommendations toEntity() => AccountabilityRecommendations()
    ..name = name
    ..date = date
    ..isUser = isUser;
}
