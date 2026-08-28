import 'package:drift/drift.dart';
import 'package:morar/core/database/block/block_dao.dart';
import 'package:morar/core/database/condominium/condominium_dao.dart';
import 'package:morar/core/database/layout/layout_dao.dart';
import 'package:morar/core/database/lello_database.dart';
import 'package:morar/core/database/me/me_dao.dart';
import 'package:morar/core/database/unit/unit_dao.dart';
import 'package:morar/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:morar/feature/me/data/model/block_model.dart';
import 'package:morar/feature/me/data/model/condominium_model.dart';
import 'package:morar/feature/me/data/model/layout_model.dart';
import 'package:morar/feature/me/data/model/me_model.dart';
import 'package:morar/feature/me/data/model/unity_model.dart';

class MeLocalDataSourceImpl extends MeLocalDataSource {
  final MeDao meDao;
  final CondominiumDao condoDao;
  final BlockDao blockDao;
  final UnitDao unitDao;
  final LayoutDao layoutDao;

  MeLocalDataSourceImpl({
    required this.meDao,
    required this.condoDao,
    required this.blockDao,
    required this.unitDao,
    required this.layoutDao,
  });

  @override
  Future<MeModel?> save(MeModel? model) async {
    await meDao.clear();
    await condoDao.clear();
    await blockDao.clear();
    await unitDao.clear();
    await layoutDao.clear();

    if (model == null) return null;

    final dataModel = MeTableCompanion(
      name: Value(model.name ?? ""),
      email: Value(model.email ?? ""),
      cpf: Value(model.cpf),
      phone: Value(model.phone),
      picture: Value(model.picture ?? ""),
      pictureHash: Value(model.pictureHash ?? ""),
      biometricPictureHash: Value(model.biometricPictureHash ?? ""),
      updated: Value(DateTime.now()),
      id: Value(model.id ?? ""),
      useFacialBiometric: Value(model.useFacialBiometric ?? false),
    );

    await meDao.insert(dataModel);

    for (var condo in model.condominiums ?? []) {
      final condoModel = CondominiumTableCompanion(
        id: Value(condo!.id ?? ""),
        name: Value(condo.name),
        address: Value(condo.address),
        regulationUrl: Value(condo.regulationUrl ?? ""),
        reference: Value(condo.reference),
        active_manager: Value(condo.active_manager),
      );
      await condoDao.insert(condoModel);

      for (var bloc in condo.blocks ?? []) {
        final blockModel = BlockTableCompanion(
          condominiumId: Value(condo.id ?? ""),
          id: Value(bloc!.id ?? ""),
          name: Value(bloc.name),
        );
        await blockDao.insert(blockModel);

        for (var unit in bloc.units ?? []) {
          final blockModel = UnitTableCompanion(
            blockId: Value(bloc.id ?? ""),
            id: Value(unit.id ?? ""),
            notificationContext: Value(unit.notificationContext ?? ""),
            title: Value(unit.title),
            rented: Value(unit.rented),
            agreement: Value(unit.agreement),
            compliant: Value(unit.compliant),
            termHomeToGo: Value(unit.termHomeToGo),
          );
          await unitDao.insert(blockModel);
        }
      }
      if (condo.layout != null) {
        final layoutModel = LayoutTableCompanion(
          id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
          condoId: Value(condo.id ?? ""),
          cod: Value(condo.layout.cod),
          name: Value(condo.layout.name),
          reference: Value(condo.layout.reference),
          primary: Value(condo.layout.primary),
          secondary: Value(condo.layout.secondary),
          logoPath: Value(condo.layout.logoPath),
        );
        await layoutDao.insert(layoutModel);
      }
    }

    return model;
  }

  @override
  Future<MeModel?> select() async {
    final meData = await meDao.get();
    if (meData == null) return null;

    final condoData = await condoDao.list();
    final blockData = await blockDao.list();
    final unitData = await unitDao.list();
    final layoutData = await layoutDao.list();

    final MeModel result = MeModel()
      ..name = meData.name
      ..email = meData.email
      ..cpf = meData.cpf
      ..phone = meData.phone
      ..picture = meData.picture
      ..pictureHash = meData.pictureHash
      ..lastUpdatedAt = meData.updated
      ..id = meData.id
      ..biometricPictureHash = meData.biometricPictureHash
      ..useFacialBiometric = meData.useFacialBiometric
      ..condominiums = condoData
          .map((condo) => CondominiumModel()
            ..id = condo.id
            ..reference = condo.reference
            ..name = condo.name
            ..address = condo.address
            ..regulationUrl = condo.regulationUrl
            ..active_manager = condo.active_manager
            ..layout = layoutData
                .where((element) => element.condoId == condo.id)
                .map<LayoutModel?>((e) => LayoutModel(
                      cod: e.cod ?? "",
                      name: e.name ?? "",
                      reference: e.reference ?? "",
                      primary: e.primary ?? "",
                      secondary: e.secondary ?? "",
                      logoPath: e.logoPath ?? "",
                    ))
                .firstWhere((_) => true, orElse: () => null)
            ..blocks = blockData
                .where((element) => element.condominiumId == condo.id)
                .map((BlockData e) => BlockModel()
                  ..id = e.id
                  ..name = e.name
                  ..units = unitData
                      .where((element) => element.blockId == e.id)
                      .map((UnitData c) => UnityModel()
                        ..id = c.id
                        ..notificationContext = c.notificationContext
                        ..title = c.title
                        ..rented = c.rented
                        ..compliant = c.compliant
                        ..agreement = c.agreement
                        ..termHomeToGo = c.termHomeToGo)
                      .toList())
                .toList())
          .toList();
    return result;
  }
}
