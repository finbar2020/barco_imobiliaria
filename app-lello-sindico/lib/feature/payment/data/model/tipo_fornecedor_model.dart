import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/tipo_fornecedor.dart';
part 'tipo_fornecedor_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TipoFornecedorModel {
  final int? idTipoFornecedor;
  final String? nomeTipoFornecedor;
  final String? codigoTipoFornecedor;

  TipoFornecedorModel({
    this.idTipoFornecedor,
    this.nomeTipoFornecedor,
    this.codigoTipoFornecedor,
  });

  factory TipoFornecedorModel.fromJson(Map<String, dynamic> json) =>
      _$TipoFornecedorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TipoFornecedorModelToJson(this);

  static TipoFornecedorModel? fromEntity(TipoFornecedorEntity? entity) {
    if (entity == null) return null;
    return TipoFornecedorModel(
      idTipoFornecedor: entity.idTipoFornecedor,
      nomeTipoFornecedor: entity.nomeTipoFornecedor,
      codigoTipoFornecedor: entity.codigoTipoFornecedor,
    );
  }

  TipoFornecedorEntity toEntity() {
    return TipoFornecedorEntity(
      idTipoFornecedor: idTipoFornecedor,
      nomeTipoFornecedor: nomeTipoFornecedor,
      codigoTipoFornecedor: codigoTipoFornecedor,
    );
  }
}
