// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/income/domain/entity/billet_found.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import 'billets_instructions.dart';

class Billet {
  final String? id;
  final Unit? unit;
  final double? value;
  final DateTime? period;
  final DateTime? bankPeriod;
  final String? situation;
  final String? nrBillet;
  final int? invoice;
  final String? code;
  final BilletsInstructions? instructions;
  final List<BilletFound>? founds;

  Billet({
    this.id,
    this.unit,
    this.value,
    this.period,
    this.bankPeriod,
    this.situation,
    this.nrBillet,
    this.invoice,
    this.code,
    this.instructions,
    this.founds,
  });
}
