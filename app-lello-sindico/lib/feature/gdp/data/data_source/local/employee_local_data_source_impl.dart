import 'package:lello/core/database/employee/employee_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/gdp/data/data_source/local/employee_local_data_source.dart';
import 'package:lello/feature/gdp/data/model/address_model.dart';
import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:drift/drift.dart';

class EmployeeLocalDataSourceImpl extends EmployeeLocalDataSource {
  final EmployeeDao dao;
  EmployeeLocalDataSourceImpl({required this.dao});

  @override
  Future<List<EmployeeModel>> list(String condominiumId) async {
    final list = await dao.list(condominiumId);
    return list
        .map((e) => EmployeeModel()
          ..id = e.id
          ..name = e.name!
          ..dob = e.dob!
          ..role = e.role!
          ..hiringDate = e.hiringDate!
          ..phone = e.phone!
          ..phone2 = e.phone2!
          ..address = (AddressModel()
            ..address = e.address!
            ..complement = e.addressComplement!
            ..number = e.addressNumber!)
          ..salary = e.salary!
          ..schooling = e.schooling!
          ..status = e.status!)
        .toList();
  }

  @override
  Future<List<EmployeeModel>> save(
      String condominiumId, List<EmployeeModel> data) async {
    final dataModels = data
        .map((e) => EmployeeTableCompanion(
              id: Value(e.id ?? ""),
              condominiumId: Value(condominiumId),
              name: Value(e.name),
              dob: Value(e.dob),
              role: Value(e.role),
              hiringDate: Value(e.hiringDate),
              phone: Value(e.phone),
              phone2: Value(e.phone2),
              address: Value(e.address?.address),
              addressNumber: Value(e.address?.number),
              addressComplement: Value(e.address?.complement),
              salary: Value(e.salary),
              schooling: Value(e.schooling),
              status: Value(e.status),
            ))
        .toList();

    await dao.insert(dataModels);
    return data;
  }
}
