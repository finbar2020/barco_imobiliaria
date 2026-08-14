import 'package:intl/intl.dart';

class BilletFound {
  String? description;
  double? value;

  BilletFound({
    this.description,
    this.value,
  });

  String get valueFormatted {
    final numberFormat = new NumberFormat(",###.00");
    return numberFormat.format(value ?? 0);
  }
}
