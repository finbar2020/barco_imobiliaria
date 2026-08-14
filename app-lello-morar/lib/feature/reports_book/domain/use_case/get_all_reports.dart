import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';

abstract class GetAllReportsUseCase
    extends UseCase<List<Report>, GetAllReportsParams> {}

class GetAllReportsParams {
  final String unitId;

  GetAllReportsParams({required this.unitId});
}
