import 'formulary_by_month_data_entity.dart';

class FormularyByMonthResponseEntity {
  final List<FormularyByMonthDataEntity> formularyByMonthDto;
  final int totalConcluidos;
  final int totalNaoConcluidos;
  final int totalGeral;

  const FormularyByMonthResponseEntity({
    required this.formularyByMonthDto,
    required this.totalConcluidos,
    required this.totalNaoConcluidos,
    required this.totalGeral,
  });
}
