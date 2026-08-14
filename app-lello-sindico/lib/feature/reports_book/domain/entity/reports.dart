import 'package:lello/feature/reports_book/domain/entity/meta.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

class Reports {
  Meta? meta;
  List<Report>? report;

  Reports({
    this.meta,
    this.report,
  });
}
