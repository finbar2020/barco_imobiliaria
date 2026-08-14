import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';

class EmployeeInfo {
  final String numCra;
  final String numCad;
  final String cpf;
  final String name;
  final String jobPosition;
  final String idLogin;
  final String pictureHash;
  final bool registered;
  final DigitalTimesheetStatusEnum statusEnum;

  EmployeeInfo({
    required this.numCra,
    required this.numCad,
    required this.cpf,
    required this.name,
    required this.jobPosition,
    required this.idLogin,
    required this.pictureHash,
    required this.registered,
    required this.statusEnum,
  });

  String get cpfFormatted {
    if (cpf.length > 1) {
      return LgpdFormatter.formatCpf(cpf);
    }
    return "${cpf.substring(0, 1).toUpperCase()}${cpf.substring(1).toLowerCase()}";
  }

  String get nameFormatted {
    List<String> names = name.split(" ");
    names = names.map((element) {
      if (element.length > 1) {
        return "${element.substring(0, 1).toUpperCase()}${element.substring(1).toLowerCase()}";
      } else {
        return element.toUpperCase();
      }
    }).toList();
    return names.join(" ");
  }

  String get jobPositionFormatted {
    List<String> jobPositions = jobPosition.split(" ");
    jobPositions = jobPositions.map((element) {
      if (element.length > 1) {
        return "${element.substring(0, 1).toUpperCase()}${element.substring(1).toLowerCase()}";
      }
      return element.toUpperCase();
    }).toList();
    return jobPositions.join(" ");
  }

  String? get pictureLink => pictureHash.isEmpty
      ? null
      : "/registration/employee/picture/file/$pictureHash";
}
