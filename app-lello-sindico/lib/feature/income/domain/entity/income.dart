// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/entity/income_forecast.dart';

import 'income_share.dart';

class Income {
  final DateTime? period;
  final double? value;
  final List<IncomeShare>? shares;
  final List<IncomeForecast>? forecast;
  final List<Billet>? pendingBillets;

  Income({
    this.period,
    this.value,
    this.shares,
    this.forecast,
    this.pendingBillets,
  });
}
