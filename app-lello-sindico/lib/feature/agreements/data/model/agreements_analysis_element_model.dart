import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';

part 'agreements_analysis_element_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsAnalysisElementModel {
  String description;
  double value;
  double percentage;

  AgreementsAnalysisElementModel({
    required this.description,
    required this.value,
    required this.percentage,
  });

  factory AgreementsAnalysisElementModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsAnalysisElementModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsAnalysisElementModelToJson(this);

  static AgreementsAnalysisElementModel fromEntity(
          AgreementsAnalysisElement entity) =>
      (AgreementsAnalysisElementModel(
        description: entity.description,
        value: entity.value,
        percentage: entity.percentage,
      ));
  AgreementsAnalysisElement toEntity() => AgreementsAnalysisElement(
        description: this.description,
        value: this.value,
        percentage: this.percentage,
      );
}
