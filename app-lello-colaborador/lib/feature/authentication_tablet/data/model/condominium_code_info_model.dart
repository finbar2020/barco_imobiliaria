import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:essentials/essentials.dart';

part 'condominium_code_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumCodeInfoModel {
  final String condoCode;
  final CondoInfoModel? condominium;
  final List<EmployeeInfoModel?> employees;

  CondominiumCodeInfoModel({
    this.condoCode = "",
    this.condominium,
    this.employees = const [],
  });

  factory CondominiumCodeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumCodeInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$CondominiumCodeInfoModelToJson(this);

  static CondominiumCodeInfoModel? fromEntity(CondominiumCodeInfo? entity) =>
      entity == null
          ? null
          : CondominiumCodeInfoModel(
              condoCode: entity.condoCode,
              condominium: CondoInfoModel.fromEntity(entity.condominium),
              employees: entity.employees
                  .map((e) => EmployeeInfoModel.fromEntity(e))
                  .toList(),
            );

  CondominiumCodeInfo? toEntity() {
    if (!isValid) {
      return null;
    }
    return CondominiumCodeInfo(
      condoCode: condoCode,
      condominium: condominium!.toEntity(),
      employees:
          employees.map((e) => e?.toEntity()).cast<EmployeeInfo>().toList(),
    );
  }

  bool get isValid {
    if (condominium == null) {
      return false;
    }
    return true;
  }
}
