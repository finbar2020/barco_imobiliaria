import 'dart:ui';

class IncomeShare {
  final String? title;
  final int? total;
  final double share;
  final Color? color;

  IncomeShare({
    this.title,
    this.total,
    this.share = 0,
    this.color,
  });
}
