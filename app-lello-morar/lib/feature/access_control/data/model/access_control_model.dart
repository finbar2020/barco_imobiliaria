import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/data/model/access_control_gest_units_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_stauts_biometric_enum.dart';

part 'access_control_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlModel {
  String? idGest;
  String? business;
  String? document;
  String? typeDocument;
  String? foreignDocument;
  String? name;
  String? phone;
  dynamic statusBiometric;
  dynamic type;
  List<AccessControlGestUnitsModel?> gestUnits;

  String? notificationParameter;

  AccessControlModel(
      {this.idGest,
      this.name,
      this.document,
      this.business,
      this.typeDocument,
      this.foreignDocument,
      this.type,
      this.phone,
      this.statusBiometric,
      this.gestUnits = const [],
      this.notificationParameter});

  factory AccessControlModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlModelToJson(this);

  static AccessControlModel? fromEntity(AccessControl? entity) => entity == null
      ? null
      : (AccessControlModel()
        ..idGest = entity.idGest
        ..name = entity.name
        ..document = entity.document
        ..business = entity.business
        ..foreignDocument = entity.foreignDocument
        ..typeDocument = entity.typeDocument
        ..type = entity.type
        ..phone = entity.phone
        ..notificationParameter = entity.notificationParameter
        ..gestUnits = entity.gestUnits
            .map((value) => AccessControlGestUnitsModel.fromEntity(value))
            .toList());

  AccessControl toEntity() => AccessControl()
    ..idGest = idGest
    ..name = name
    ..document = document
    ..business = business
    ..foreignDocument = foreignDocument
    ..typeDocument = typeDocument
    ..type = type
    ..phone = phone
    ..statusBiometric = statusBiometric == null || statusBiometric == 0
        ? StatusBiometric.NAO_CADASTRADA
        : stringToEnum(StatusBiometric.values, statusBiometric)
    ..notificationParameter = notificationParameter
    ..gestUnits = this.gestUnits.isNotEmpty
        ? this.gestUnits.map((model) => model!.toEntity()).toList()
        : [];
}
