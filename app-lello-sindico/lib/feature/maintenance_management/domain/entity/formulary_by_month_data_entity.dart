import 'formulary_data_point_entity.dart';

class FormularyByMonthDataEntity {
  final String name;
  final List<FormularyDataPointEntity> data;

  const FormularyByMonthDataEntity({
    required this.name,
    required this.data,
  });
}
