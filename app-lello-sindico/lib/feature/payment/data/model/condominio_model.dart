import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/condominio.dart';
part 'condominio_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominioModel {
  final String cnpj;
  final int idCondo;

  CondominioModel({
    required this.cnpj,
    required this.idCondo,
  });

  factory CondominioModel.fromJson(Map<String, dynamic> json) =>
      _$CondominioModelFromJson(json);

  Map<String, dynamic> toJson() => _$CondominioModelToJson(this);

  factory CondominioModel.fromEntity(CondominioEntity entity) {
    return CondominioModel(
      cnpj: entity.cnpj,
      idCondo: entity.idCondo,
    );
  }

  CondominioEntity toEntity() {
    return CondominioEntity(
      cnpj: cnpj,
      idCondo: idCondo,
    );
  }
}
