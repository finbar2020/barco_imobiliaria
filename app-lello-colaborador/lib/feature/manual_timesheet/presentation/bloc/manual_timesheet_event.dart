import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:essentials/essentials.dart';

abstract class ManualTimeSheetEvent extends Equatable {
  const ManualTimeSheetEvent();

  @override
  List<Object?> get props => [];
}

class SendManualTimeSheetEvent extends ManualTimeSheetEvent {
  final ManualTimeSheetEntity manualTimeSheetEntity;
  const SendManualTimeSheetEvent({
    required this.manualTimeSheetEntity,
  });

  @override
  List<Object?> get props => [manualTimeSheetEntity];
}
