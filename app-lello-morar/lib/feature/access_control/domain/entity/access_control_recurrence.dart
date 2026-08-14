import 'package:morar/feature/access_control/domain/entity/access_control_itens.dart';

class AccessControlRecurrence {
  String? idRecurrence;
  String? recurrenceType;
  int? interval;
  List<AccessControlItens>? itens;

  AccessControlRecurrence({
    this.idRecurrence,
    this.recurrenceType,
    this.interval,
    this.itens,
  });

  @override
  String toString() {
    return 'AccessControlRecurrence(idRecurrence: $idRecurrence, recurrenceType: $recurrenceType, interval: $interval, itens: $itens)';
  }
}
