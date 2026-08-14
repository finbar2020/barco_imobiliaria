import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:colaborador/core/database/authentication_tablet_database/condominium_info/condominium_info_dao.dart';
import 'package:colaborador/core/database/authentication_tablet_database/employee_info/employee_info_dao.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:drift/drift.dart';

class AuthenticationTabletLocalDataSourceImpl
    extends AuthenticationTabletLocalDataSource {
  CondominiumInfoDao condominiumInfoDao;
  EmployeeInfoDao employeeInfoDao;
  AuthenticationTabletLocalDataSourceImpl({
    required this.condominiumInfoDao,
    required this.employeeInfoDao,
  });

  @override
  Future<bool> delete() async {
    await condominiumInfoDao.clear();
    await employeeInfoDao.clear();
    return true;
  }

  @override
  Future<CondominiumCodeInfoModel> save(
      String condoCode, CondominiumCodeInfoModel model) async {
    await delete();
    final condominiumInfoTableCompanion = CondominiumInfoTableCompanion(
      condoCode: Value(condoCode),
      reference: Value(model.condominium!.reference),
      name: Value(model.condominium!.name),
      picturehash: Value(model.condominium!.picturehash),
      status: Value(model.condominium!.status),
      ref: Value(model.condominium!.ref),
    );

    final employeeInfoTableCompanion = model.employees
        .cast<EmployeeInfoModel>()
        .map((e) => EmployeeInfoTableCompanion(
              condoCode: Value(condoCode),
              numCad: Value(e.numCad),
              cpf: Value(e.cpf),
              name: Value(e.name),
              jobPosition: Value(e.jobPosition),
              idLogin: Value(e.idLogin),
              pictureHash: Value(e.pictureHash),
              registered: Value(e.registered),
              numCra: Value(e.numCra),
              status: Value(e.status),
            ))
        .toList();

    await condominiumInfoDao.insert(condominiumInfoTableCompanion);

    await Future.wait(
      List.generate(
        employeeInfoTableCompanion.length,
        (index) => employeeInfoDao.insert(employeeInfoTableCompanion[index]),
      ),
    );
    return model;
  }

  @override
  Future<CondominiumCodeInfoModel?> select(String condoCode) async {
    final CondominiumInfoData? condominiumInfoData =
        await condominiumInfoDao.get(condoCode);
    if (condominiumInfoData == null) {
      return null;
    }
    final List<EmployeeInfoData> employeeInfoData =
        await employeeInfoDao.get(condoCode);
    if (employeeInfoData.isEmpty) {
      return null;
    }
    CondominiumCodeInfoModel model = CondominiumCodeInfoModel(
      condoCode: condoCode,
      condominium: CondoInfoModel(
        reference: condominiumInfoData.reference,
        name: condominiumInfoData.name,
        picturehash: condominiumInfoData.picturehash,
        status: condominiumInfoData.status,
        ref: condominiumInfoData.ref,
      ),
      employees: employeeInfoData
          .map((e) => EmployeeInfoModel(
                numCad: e.numCad,
                cpf: e.cpf,
                name: e.name,
                jobPosition: e.jobPosition,
                idLogin: e.idLogin,
                pictureHash: e.pictureHash,
                registered: e.registered,
                numCra: e.numCra,
                status: e.status,
              ))
          .toList(),
    );

    return model;
  }
}
