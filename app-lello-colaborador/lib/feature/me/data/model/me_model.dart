import 'package:colaborador/feature/me/data/model/condominium_model.dart';
import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MeModel {
  String id;
  String name;
  String email;
  String cpf;
  String phone;
  String? picture;
  String? pictureHash;
  List<CondominiumModel> condominiums;
  bool? isTabletSession;

  MeModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.cpf = "",
    this.phone = "",
    this.picture,
    this.pictureHash,
    this.condominiums = const [],
    this.isTabletSession = false,
  });

  factory MeModel.fromJson(Map<String, dynamic> json) =>
      _$MeModelFromJson(json);
  Map<String, dynamic> toJson() => _$MeModelToJson(this);

  static MeModel? fromEntity(Me? me) => me == null
      ? null
      : (MeModel(
          name: me.name,
          id: me.id,
          email: me.email,
          picture: me.picture,
          pictureHash: me.pictureHash,
          cpf: me.cpf,
          phone: me.phone,
          condominiums: me.condominiums
              .map((e) => CondominiumModel.fromEntity(e))
              .toList()
              .cast<CondominiumModel>(),
          isTabletSession: me.isTabletSession,
        ));

  Me toEntity() => Me(
        name: name,
        id: id,
        email: email,
        picture: picture,
        pictureHash: pictureHash,
        cpf: cpf,
        phone: phone,
        condominiums:
            condominiums.map((e) => e.toEntity()).toList().cast<Condominium>(),
        isTabletSession: isTabletSession,
      );
}
