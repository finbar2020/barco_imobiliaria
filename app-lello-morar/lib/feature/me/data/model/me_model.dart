import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/me/data/model/condominium_model.dart';
import 'package:morar/feature/me/domain/entity/me.dart';

part 'me_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MeModel {
  String? name;
  String? id;
  String? email;
  String? cpf;
  String? phone;
  String? picture;
  String? pictureHash;
  String? biometricPictureHash;
  List<CondominiumModel?>? condominiums;
  DateTime? lastUpdatedAt;
  bool? useFacialBiometric;

  MeModel();

  factory MeModel.fromJson(Map<String, dynamic> json) =>
      _$MeModelFromJson(json);
  Map<String, dynamic> toJson() => _$MeModelToJson(this);

  static MeModel? fromEntity(Me? me) => me == null
      ? null
      : (MeModel()
        ..name = me.name
        ..id = me.id
        ..email = me.email
        ..picture = me.picture
        ..cpf = me.cpf
        ..phone = me.phone
        ..pictureHash = me.pictureHash
        ..biometricPictureHash = me.biometricPictureHash
        ..condominiums =
            me.condominiums?.map((e) => CondominiumModel.fromEntity(e)).toList()
        ..lastUpdatedAt = me.lastUpdatedAt
        ..useFacialBiometric = me.useFacialBiometric ?? false);

  Me? toEntity() => Me()
    ..name = this.name
    ..id = this.id
    ..email = this.email
    ..picture = this.picture
    ..cpf = this.cpf
    ..phone = this.phone
    ..pictureHash = this.pictureHash
    ..biometricPictureHash = this.biometricPictureHash
    ..condominiums = this.condominiums?.map((e) => e!.toEntity()).toList()
    ..lastUpdatedAt = this.lastUpdatedAt
    ..useFacialBiometric = this.useFacialBiometric ?? false;
}
