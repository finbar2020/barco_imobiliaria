import '../data/model/task_by_month_data_point_model.dart';
import '../data/model/task_by_month_data_model.dart';
import '../data/model/task_by_month_response_model.dart';
import '../domain/entity/task_by_month_data_point_entity.dart';
import '../domain/entity/task_by_month_data_entity.dart';
import '../domain/entity/task_by_month_response_entity.dart';

extension TaskByMonthDataPointModelAdapter on TaskByMonthDataPointModel {
  TaskByMonthDataPointEntity get toEntity => TaskByMonthDataPointEntity(
        key: key,
        value: value,
      );
}

extension TaskByMonthDataModelAdapter on TaskByMonthDataModel {
  TaskByMonthDataEntity get toEntity {
    print("🔄 [ADAPTER] Mapeando série: $name com ${data.length} pontos");
    return TaskByMonthDataEntity(
      name: name,
      data: data.map((e) => e.toEntity).toList(),
    );
  }
}

extension TaskByMonthResponseModelAdapter on TaskByMonthResponseModel {
  TaskByMonthResponseEntity get toEntity {
    print("🔄 [ADAPTER] TaskByMonth - mapeando resposta");
    print("🔄 [ADAPTER] FormularyByMonthDto count: ${formularyByMonthDto.length}");
    print("🔄 [ADAPTER] Total geral: $totalGeral, concluídos: $totalConcluidos");
    
    final result = TaskByMonthResponseEntity(
      formularyByMonthDto: formularyByMonthDto.map((e) => e.toEntity).toList(),
      totalConcluidos: totalConcluidos,
      totalNaoConcluidos: totalNaoConcluidos,
      totalGeral: totalGeral,
    );
    
    print("🔄 [ADAPTER] Entity formularyByMonthDto count: ${result.formularyByMonthDto.length}");
    return result;
  }
}