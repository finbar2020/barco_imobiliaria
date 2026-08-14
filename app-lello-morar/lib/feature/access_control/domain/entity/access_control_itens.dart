import 'package:morar/feature/access_control/domain/entity/access_control_date.dart';

class AccessControlItens {
  int? recurrenceValue;
  AccessControlDate? start;
  AccessControlDate? end;

  AccessControlItens({
    this.recurrenceValue,
    this.start,
    this.end,
  });

  @override
  String toString() =>
      'AccessControlItens(recurrenceValue: $recurrenceValue, start: $start, end: $end)';
}
