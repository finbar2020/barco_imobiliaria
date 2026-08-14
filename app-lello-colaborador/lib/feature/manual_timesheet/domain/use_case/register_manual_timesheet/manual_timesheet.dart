import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:essentials/essentials.dart';

abstract class RegisterManualTimeSheetUsecase
    extends UseCase<ManualTimeSheetEntity, RegisterManualTimeSheetParam> {}

class RegisterManualTimeSheetParam {
  final String condoId;
  final String meId;
  final ManualTimeSheetEntity manualTimeSheetEntity;

  RegisterManualTimeSheetParam({
    required this.condoId,
    required this.meId,
    required this.manualTimeSheetEntity,
  });
}
