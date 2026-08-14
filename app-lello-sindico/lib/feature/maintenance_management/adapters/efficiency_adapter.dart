import '../data/model/efficiency_response_model.dart';
import '../data/model/task_summary_model.dart';
import '../domain/entity/efficiency_entity.dart';

extension EfficiencyItemModelAdapter on EfficiencyItemModel {
  EfficiencyItemEntity get toEntity => EfficiencyItemEntity(
        id: id,
        name: name,
        done: done,
        notStarted: notStarted,
        draft: draft,
      );
}

extension TaskSummaryModelEfficiencyAdapter on TaskSummaryModel {
  TaskSummaryEntity get toEfficiencyEntity => TaskSummaryEntity(
        total: total,
        done: done,
        notStarted: notStarted,
        draft: draft,
      );
}

extension EfficiencyResponseModelAdapter on EfficiencyResponseModel {
  EfficiencyResponseEntity get toEntity => EfficiencyResponseEntity(
        efficiencyResponse: efficiencyResponse.map((e) => e.toEntity).toList(),
        taskSummary: taskSummary.toEfficiencyEntity,
      );
}
