import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/data/model/layout_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_manager_biometric_status.dart';

part 'condominium_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumModel {
  String id;
  String? name;
  String? number;
  String? address;
  String? regulationUrl;
  String reference;
  bool useFacialBiometric;
  String managerAccessControlBiometricStatus;
  LayoutModel? layout;
  final String? notificationContext;

  CondominiumModel({
    required this.id,
    this.name,
    this.number,
    this.address,
    this.regulationUrl,
    required this.reference,
    this.useFacialBiometric = false,
    this.managerAccessControlBiometricStatus = "unavaliable",
    this.layout,
    this.notificationContext,
  });

  factory CondominiumModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumModelFromJson(json);
  Map<String, dynamic> toJson() => _$CondominiumModelToJson(this);

  static CondominiumModel? fromEntity(Condominium? entity) => entity == null
      ? null
      : (CondominiumModel(
          id: entity.id,
          name: entity.name,
          number: entity.number,
          address: entity.address,
          regulationUrl: entity.regulationUrl,
          reference: entity.reference,
          useFacialBiometric: entity.useFacialBiometric,
          layout: LayoutModel.fromEntity(entity.layout),
          managerAccessControlBiometricStatus:
              enumToString(entity.managerAccessControlBiometricStatus) ??
                  "unavaliable",
          notificationContext: entity.notificationContext,
        ));

  Condominium toEntity() => Condominium(
        id: id,
        name: name,
        number: number,
        address: address,
        regulationUrl: regulationUrl,
        layout: layout?.toEntity(),
        reference: reference,
        useFacialBiometric: useFacialBiometric,
        managerAccessControlBiometricStatus: stringToEnum(
                CondominiumManagerAccessControlBiometricStatusEnum.values,
                managerAccessControlBiometricStatus) ??
            CondominiumManagerAccessControlBiometricStatusEnum.unavailable,
        notificationContext: notificationContext,
      );
}
