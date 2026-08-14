import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreements_analysis_element_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_finished.dart';

part 'agreements_finished_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsFinishedModel {
  int agreementsPerformedAutomaticallyQtd;
  int agreementsManuallyApprovedQtd;
  List<AgreementsAnalysisElementModel> reportPaymentMethod;
  List<AgreementsAnalysisElementModel> reportInstallments;
  List<AgreementsAnalysisElementModel> reportDueDate;

  AgreementsFinishedModel({
    required this.agreementsPerformedAutomaticallyQtd,
    required this.agreementsManuallyApprovedQtd,
    this.reportPaymentMethod = const [],
    this.reportInstallments = const [],
    this.reportDueDate = const [],
  });

  factory AgreementsFinishedModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsFinishedModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsFinishedModelToJson(this);

  static AgreementsFinishedModel? fromEntity(AgreementsFinished? entity) =>
      entity == null
          ? null
          : (AgreementsFinishedModel(
              agreementsPerformedAutomaticallyQtd:
                  entity.agreementsPerformedAutomaticallyQtd,
              agreementsManuallyApprovedQtd:
                  entity.agreementsManuallyApprovedQtd,
              reportPaymentMethod: entity.reportPaymentMethod
                  .map((e) => AgreementsAnalysisElementModel.fromEntity(e))
                  .toList(),
              reportInstallments: entity.reportInstallments
                  .map((e) => AgreementsAnalysisElementModel.fromEntity(e))
                  .toList(),
              reportDueDate: entity.reportDueDate
                  .map((e) => AgreementsAnalysisElementModel.fromEntity(e))
                  .toList(),
            ));
  AgreementsFinished toEntity() => AgreementsFinished(
        agreementsPerformedAutomaticallyQtd:
            this.agreementsPerformedAutomaticallyQtd,
        agreementsManuallyApprovedQtd: this.agreementsManuallyApprovedQtd,
        reportPaymentMethod:
            this.reportPaymentMethod.map((e) => e.toEntity()).toList(),
        reportInstallments:
            this.reportInstallments.map((e) => e.toEntity()).toList(),
        reportDueDate: this.reportDueDate.map((e) => e.toEntity()).toList(),
      );
}
