// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/data/model/condominium_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

part 'me_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MeModel {
  final String? name;
  final String? id;
  final String? email;
  final String? cpf;
  final String? phone;
  final String? picture;
  final String? pictureHash;
  final List<CondominiumModel?>? condominiums;

  MeModel({
    this.name,
    this.id,
    this.email,
    this.cpf,
    this.phone,
    this.picture,
    this.pictureHash,
    this.condominiums,
  });

  factory MeModel.fromJson(Map<String, dynamic> json) =>
      _$MeModelFromJson(json);
  Map<String, dynamic> toJson() => _$MeModelToJson(this);

  factory MeModel.fromEntity(Me me) {
    return MeModel(
      name: me.name,
      id: me.id,
      email: me.email,
      picture: me.picture,
      pictureHash: me.pictureHash,
      cpf: me.cpf,
      phone: me.phone,
      condominiums:
          me.condominiums?.map((e) => CondominiumModel.fromEntity(e)).toList(),
    );
  }

  Me toEntity() {
    return Me(
      name: name,
      id: id,
      email: email,
      picture: picture,
      pictureHash: pictureHash,
      cpf: cpf,
      phone: phone,
      condominiums: condominiums?.map((e) => e!.toEntity()).toList(),
    );
  }

  MeModel copyWith({
    String? name,
    String? id,
    String? email,
    String? cpf,
    String? phone,
    String? picture,
    String? pictureHash,
    List<CondominiumModel?>? condominiums,
  }) {
    return MeModel(
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      picture: picture ?? this.picture,
      pictureHash: pictureHash ?? this.pictureHash,
      condominiums: condominiums ?? this.condominiums,
    );
  }
}
