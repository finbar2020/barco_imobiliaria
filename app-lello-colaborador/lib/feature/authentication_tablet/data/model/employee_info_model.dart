import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';

part 'employee_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EmployeeInfoModel {
  final String numCra;
  final String numCad;
  final String cpf;
  final String name;
  final String jobPosition;
  final String idLogin;
  final String pictureHash;
  final bool registered;
  final String status;

  EmployeeInfoModel({
    this.numCra = "",
    this.numCad = "",
    this.cpf = "",
    this.name = "",
    this.jobPosition = "",
    this.idLogin = "",
    this.pictureHash = "",
    this.registered = false,
    this.status = "pending",
  });

  factory EmployeeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeInfoModelToJson(this);

  static EmployeeInfoModel? fromEntity(EmployeeInfo? entity) => entity == null
      ? null
      : EmployeeInfoModel(
          numCra: entity.numCra,
          numCad: entity.numCad,
          cpf: entity.cpf,
          name: entity.name,
          jobPosition: entity.jobPosition,
          idLogin: entity.idLogin,
          pictureHash: entity.pictureHash,
          registered: entity.registered,
          status: enumToString(entity.statusEnum) ?? "pending",
        );

  EmployeeInfo toEntity() => EmployeeInfo(
        numCra: numCra,
        numCad: numCad,
        cpf: cpf,
        name: name,
        jobPosition: jobPosition,
        idLogin: idLogin,
        pictureHash: pictureHash,
        registered: registered,
        statusEnum: stringToEnum(DigitalTimesheetStatusEnum.values, status) ??
            DigitalTimesheetStatusEnum.pending,
      );
}
