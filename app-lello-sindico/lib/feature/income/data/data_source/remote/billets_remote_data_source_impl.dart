import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/income/data/data_source/remote/billets_remote_data_source.dart';
import 'package:lello/feature/income/data/model/billet_model.dart';
import 'package:lello/feature/income/data/model/billet_period_availability_model.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';
import 'package:path_provider/path_provider.dart';

import 'billets_api.dart';

class BilletsRemoteDataSourceImpl extends BilletsRemoteDataSource {
  final BilletsApi api;
  final DateFormat dateFormat = DateFormat("yyyy-MM");

  BilletsRemoteDataSourceImpl({required this.api});

  @override
  Future<Billet?> get(
      String condominiumId, String unitId, DateTime period) async {
    final response =
        await api.get(condominiumId, unitId, dateFormat.format(period));
    if (response.statusCode == 404 || response.body == "") return null;
    final result =
        ApiMapper.map(response, (json) => BilletModel.fromJson(json));
    return result.toEntity();
  }

  @override
  Future<List<UnitModel>> getUnitsByBillets({
    required String condominiumId,
    required String? query,
    required String? status,
    required DateTime? period,
    String? lastUnitId,
    bool? loadAll,
  }) async {
    final response = await api.getUnitsByBillets(
        condominiumId, query, status, period, lastUnitId, loadAll);
    final result =
        ApiMapper.mapList(response, (json) => UnitModel.fromJson(json));

    return result.map((e) => e.copyWith(condominiumId: condominiumId)).toList();
  }

  @override
  Future<XFile?> downloadPdf({
    required Billet billet,
    required String reference,
  }) async {
    final response = await api.downloadPdf(billet.nrBillet!);
    if (response.statusCode == 204 || response.body['data'] == "") return null;

    Directory dir = await getApplicationDocumentsDirectory();

    final File file = File(
      "${dir.path}/$reference-${billet.unit!.id!}-${billet.period!.toFormattedFileString()}.pdf",
    );
    file.createSync();

    await file.writeAsBytes(base64.decode(response.body['data']));

    return XFile(file.path);
  }

  @override
  Future<BilletPeriodsAvailabilityModel> getBilletPeriodAvailability({
    required String condominiumId, required int? limit, required int? page,
  }) async {
    final response = await api.getBilletPeriodAvailability(
      condominiumId, limit, page,
    );
    return ApiMapper.map(
        response, (json) => BilletPeriodsAvailabilityModel.fromJson(json));
  }
}
