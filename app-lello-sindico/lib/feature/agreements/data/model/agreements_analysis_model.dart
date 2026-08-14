import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreements_finished_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_refused_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis.dart';

part 'agreements_analysis_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsAnalysisModel {
  DateTime fromDate;
  DateTime toDate;
  AgreementsFinishedModel? reportApproved;
  AgreementsRefusedModel? reportReproved;

  AgreementsAnalysisModel({
    required this.fromDate,
    required this.toDate,
    this.reportApproved,
    this.reportReproved,
  });

  factory AgreementsAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsAnalysisModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsAnalysisModelToJson(this);

  static AgreementsAnalysisModel? fromEntity(AgreementsAnalysis? entity) =>
      entity == null
          ? null
          : (AgreementsAnalysisModel(
              fromDate: entity.fromDate, toDate: entity.toDate)
            ..reportApproved =
                AgreementsFinishedModel.fromEntity(entity.reportApproved)
            ..reportReproved =
                AgreementsRefusedModel.fromEntity(entity.reportReproved));
  AgreementsAnalysis toEntity() => AgreementsAnalysis(
        reportApproved: this.reportApproved?.toEntity(),
        reportReproved: this.reportReproved?.toEntity(),
        fromDate: this.fromDate,
        toDate: this.toDate,
      );
}
