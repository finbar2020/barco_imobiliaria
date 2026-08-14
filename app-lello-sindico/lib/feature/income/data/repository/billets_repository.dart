import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/entity/billet_periods_availability.dart';

import '../../../unit/domain/entity/unit.dart';
import '../../domain/entity/billet_filter_parameters.dart';

abstract class BilletsRepository {
  Future<Try<Billet?>> get(
      String condominiumId, String unitId, DateTime period);
  Future<Try<List<Unit>>> getUnitsByBillets(
    String condominiumId,
    BilletFilter filter,
  );

  Future<Try<BilletPeriodAvailability>> getBilletPeriodAvailability(
      {required String condominiumId, required int? limit, required int? page});
  Future<Try<XFile?>> downloadPdf({
    required Billet billet,
    required String reference,
  });
}
