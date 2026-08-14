import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreements_analysis_element_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_refused.dart';

part 'agreements_refused_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsRefusedModel {
  int agreementsReprovedQtd;
  List<AgreementsAnalysisElementModel> reportReprovedReason;
  List<AgreementsAnalysisElementModel> reportInstallments;
  List<AgreementsAnalysisElementModel> reportDueDate;

  AgreementsRefusedModel({
    required this.agreementsReprovedQtd,
    required this.reportReprovedReason,
    required this.reportInstallments,
    required this.reportDueDate,
  });

  factory AgreementsRefusedModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsRefusedModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsRefusedModelToJson(this);

  static AgreementsRefusedModel? fromEntity(AgreementsRefused? entity) =>
      entity == null
          ? null
          : (AgreementsRefusedModel(
              agreementsReprovedQtd: entity.agreementsReprovedQtd,
              reportReprovedReason: entity.reportReprovedReason
                  .map((e) => AgreementsAnalysisElementModel.fromEntity(e))
                  .toList(),
              reportInstallments: entity.reportInstallments
                  .map((e) => AgreementsAnalysisElementModel.fromEntity(e))
                  .toList(),
              reportDueDate: entity.reportDueDate
                  .map((e) => AgreementsAnalysisElementModel.fromEntity(e))
                  .toList(),
            ));
  AgreementsRefused toEntity() => AgreementsRefused(
        agreementsReprovedQtd: this.agreementsReprovedQtd,
        reportReprovedReason:
            this.reportReprovedReason.map((e) => e.toEntity()).toList(),
        reportInstallments:
            this.reportInstallments.map((e) => e.toEntity()).toList(),
        reportDueDate: this.reportDueDate.map((e) => e.toEntity()).toList(),
      );
}
