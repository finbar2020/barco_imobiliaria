import 'package:drift/drift.dart';
import 'package:lello/core/database/condominium/condominium_dao.dart';
import 'package:lello/core/database/condominium_balance/condominium_balance_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_debits_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_detail_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_summary_dao.dart';
import 'package:lello/core/database/layout/layout_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/me/me_dao.dart';
import 'package:lello/feature/condominium/data/model/condominium_model.dart';
import 'package:lello/feature/condominium/data/model/layout_model.dart';
import 'package:lello/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:lello/feature/me/data/model/me_model.dart';

class MeLocalDataSourceImpl extends MeLocalDataSource {
  final MeDao meDao;
  final CondominiumDao condominiumDao;
  final CondominiumBalanceDao condominiumBalanceDao;
  final CondominiumBalanceDebitsDao condominiumBalanceDebitsDao;
  final CondominiumBalanceDetailDao condominiumBalanceDetailDao;
  final CondominiumBalanceSummaryDao condominiumBalanceSummaryDao;
  final LayoutDao layoutDao;

  MeLocalDataSourceImpl({
    required this.meDao,
    required this.condominiumDao,
    required this.condominiumBalanceDao,
    required this.condominiumBalanceDebitsDao,
    required this.condominiumBalanceDetailDao,
    required this.condominiumBalanceSummaryDao,
    required this.layoutDao,
  });

  @override
  Future<MeModel?> save(MeModel? model) async {
    if (model == null) {
      await meDao.clear();
      await condominiumDao.clear();
      await condominiumBalanceDao.clear();
      await condominiumBalanceDebitsDao.clear();
      await condominiumBalanceDetailDao.clear();
      await condominiumBalanceSummaryDao.clear();
      await layoutDao.clear();
      return model;
    }

    final dataModel = MeTableCompanion(
        name: Value(model.name!),
        email: Value(model.email ?? ""),
        cpf: Value(model.cpf),
        phone: Value(model.phone),
        picture: Value(model.picture),
        pictureHash: Value(model.pictureHash));

    final condominiumDataModel = model.condominiums!
        .map((e) => CondominiumTableCompanion(
              id: Value(e!.id),
              name: Value(e.name!),
              address: Value(e.address!),
              reference: Value(e.reference),
              useFacialBiometric: Value(e.useFacialBiometric),
              managerAccessControlBiometricStatus:
                  Value(e.managerAccessControlBiometricStatus),
              notificationContext: Value(e.notificationContext),
            ))
        .toList();

    if (model.condominiums!.isNotEmpty) {
      await layoutDao.clear();
      List.generate(model.condominiums!.length, (index) async {
        if (model.condominiums?[index]?.layout != null) {
          final layoutModel = LayoutTableCompanion(
            id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
            condoId: Value(model.condominiums?[index]?.id ?? ""),
            cod: Value(model.condominiums?[index]?.layout?.cod),
            name: Value(model.condominiums?[index]?.layout?.name),
            reference: Value(model.condominiums?[index]?.layout?.reference),
            primary: Value(model.condominiums?[index]?.layout?.primary),
            secondary: Value(model.condominiums?[index]?.layout?.secondary),
            logoPath: Value(model.condominiums?[index]?.layout?.logoPath),
          );
          await layoutDao.insert(layoutModel);
        }
      });
      // model.condominiums!.map((e) async {
      //   if (e?.layout != null) {
      //     final layoutModel = LayoutTableCompanion(
      //       id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
      //       condoId: Value(e?.id ?? ""),
      //       cod: Value(e?.layout?.cod),
      //       name: Value(e?.layout?.name),
      //       reference: Value(e?.layout?.reference),
      //       primary: Value(e?.layout?.primary),
      //       secondary: Value(e?.layout?.secondary),
      //       logoPath: Value(e?.layout?.logoPath),
      //     );
      //     await layoutDao.insert(layoutModel);
      //   }
      // });
    }

    await meDao.clear();
    await meDao.insert(dataModel);
    await condominiumDao.clear();
    await condominiumDao.insert(condominiumDataModel);

    return model;
  }

  @override
  Future<MeModel?> select() async {
    final meData = await meDao.get();
    if (meData == null) {
      return null;
    }
    final condos = await condominiumDao.list();
    final layout = await layoutDao.list();

    final MeModel result = MeModel(
      name: meData.name,
      email: meData.email,
      cpf: meData.cpf!,
      phone: meData.phone,
      picture: meData.picture,
      pictureHash: meData.pictureHash,
      condominiums: [],
    );
    if (condos.isNotEmpty) {
      return result.copyWith(
        condominiums: condos
            .map((e) => CondominiumModel(
                id: e.id,
                name: e.name,
                address: e.address,
                reference: e.reference,
                useFacialBiometric: e.useFacialBiometric,
                managerAccessControlBiometricStatus:
                    e.managerAccessControlBiometricStatus,
                notificationContext: e.notificationContext,
                layout: layout.isNotEmpty
                    ? layout
                        .where((la) => la.condoId == e.id)
                        .map((item) => LayoutModel(
                              cod: item.cod ?? "",
                              name: item.name ?? "",
                              reference: item.reference ?? "",
                              primary: item.primary ?? "",
                              secondary: item.secondary ?? "",
                              logoPath: item.logoPath ?? "",
                            ))
                        .toList()
                        .first
                    : null))
            .toList(),
      );
    }
    return result;
  }
}
