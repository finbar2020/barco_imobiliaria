import '../data/model/formulary_data_point_model.dart';
import '../data/model/formulary_by_month_data_model.dart';
import '../data/model/formulary_by_month_response_model.dart';
import '../domain/entity/formulary_data_point_entity.dart';
import '../domain/entity/formulary_by_month_data_entity.dart';
import '../domain/entity/formulary_by_month_response_entity.dart';

extension FormularyDataPointModelAdapter on FormularyDataPointModel {
  FormularyDataPointEntity get toEntity => FormularyDataPointEntity(
        key: key,
        value: value,
      );
}

extension FormularyByMonthDataModelAdapter on FormularyByMonthDataModel {
  FormularyByMonthDataEntity get toEntity => FormularyByMonthDataEntity(
        name: name,
        data: data.map((e) => e.toEntity).toList(),
      );
}

extension FormularyByMonthResponseModelAdapter on FormularyByMonthResponseModel {
  FormularyByMonthResponseEntity get toEntity => FormularyByMonthResponseEntity(
        formularyByMonthDto: formularyByMonthDto.map((e) => e.toEntity).toList(),
        totalConcluidos: totalConcluidos,
        totalNaoConcluidos: totalNaoConcluidos,
        totalGeral: totalGeral,
      );
}
