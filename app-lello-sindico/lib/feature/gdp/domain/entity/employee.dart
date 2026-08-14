import 'package:lello/feature/access_management/domain/entity/access_control_enum.dart';
import 'package:lello/feature/gdp/domain/entity/address.dart';

class Employee {
  String? id;
  String? name;
  DateTime? dob;
  String? role;
  DateTime? hiringDate;
  String? phone;
  String? phone2;
  Address? address;
  double? salary;
  String? schooling;
  String? status;
  String? picture;
  String? cpf;
  AccessControlBiometricStatus? statusBiometriaColaborador;
  bool? useApp;

  bool get condoHasBiometric =>
      statusBiometriaColaborador != null &&
      statusBiometriaColaborador != AccessControlBiometricStatus.unavailable;

  bool get userHasBiometric =>
      statusBiometriaColaborador == AccessControlBiometricStatus.registered;
}
