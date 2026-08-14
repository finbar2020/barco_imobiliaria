import 'package:cross_file/cross_file.dart';
import 'package:lello/feature/income/data/model/billet_period_availability_model.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';

abstract class BilletsRemoteDataSource {
  Future<Billet?> get(String condominiumId, String unitId, DateTime period);

  Future<List<UnitModel>> getUnitsByBillets(
      {required String condominiumId,
      required String? query,
      required String? status,
      required DateTime? period,
      String? lastUnitId,
      bool? loadAll});
  Future<XFile?> downloadPdf({
    required Billet billet,
    required String reference,
  });

  Future<BilletPeriodsAvailabilityModel> getBilletPeriodAvailability(
      {required String condominiumId, required int? limit, required int? page});
}
