import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_enum.dart';
import 'package:lello/feature/gdp/data/model/address_model.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

part 'employee_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EmployeeModel {
  String? id;
  String? name;
  DateTime? dob;
  String? role;
  DateTime? hiringDate;
  String? phone;
  String? phone2;
  AddressModel? address;
  double? salary;
  String? schooling;
  String? status;
  String? picture;
  String? cpf;
  String? accessControlBiometricStatus;
  bool? useApp;

  EmployeeModel();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  static EmployeeModel? fromEntity(Employee? entity) => entity == null
      ? null
      : (EmployeeModel()
        ..id = entity.id
        ..name = entity.name
        ..dob = entity.dob
        ..role = entity.role
        ..hiringDate = entity.hiringDate
        ..phone = entity.phone
        ..phone2 = entity.phone2
        ..address = AddressModel.fromEntity(entity.address)
        ..salary = entity.salary
        ..schooling = entity.schooling
        ..status = entity.status
        ..picture = entity.picture
        ..cpf = entity.cpf
        ..accessControlBiometricStatus =
            enumToString(entity.statusBiometriaColaborador)
        ..useApp = entity.useApp);

  Employee toEntity() => Employee()
    ..id = this.id
    ..name = this.name
    ..dob = this.dob
    ..role = this.role
    ..hiringDate = this.hiringDate
    ..phone = this.phone?.isEmpty == true ? null : this.phone
    ..phone2 = this.phone2?.isEmpty == true ? null : this.phone2
    ..address = this.address?.toEntity()
    ..salary = this.salary
    ..schooling = this.schooling
    ..status = this.status
    ..picture = this.picture
    ..cpf = this.cpf
    ..statusBiometriaColaborador = accessControlBiometricStatus != null &&
            accessControlBiometricStatus != ""
        ? stringToEnum(AccessControlBiometricStatus.values,
            this.accessControlBiometricStatus)
        : AccessControlBiometricStatus.unavailable
    ..useApp = this.useApp ?? false;
}
