import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:essentials/essentials.dart';

part 'condo_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondoInfoModel {
  final String reference;
  final String name;
  final String picturehash;
  final String status;

  ///Referencia sem hash da c# para busca do firebase
  final String ref;

  CondoInfoModel({
    this.reference = "",
    this.name = "",
    this.picturehash = "",
    this.status = "",
    this.ref = "",
  });

  factory CondoInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CondoInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$CondoInfoModelToJson(this);

  static CondoInfoModel? fromEntity(CondoInfo? entity) => entity == null
      ? null
      : CondoInfoModel(
          reference: entity.reference,
          name: entity.name,
          picturehash: entity.picturehash,
          status: entity.status,
          ref: entity.ref,
        );

  CondoInfo toEntity() => CondoInfo(
        reference: reference,
        name: name,
        picturehash: picturehash,
        status: status,
        ref: ref,
      );
}
