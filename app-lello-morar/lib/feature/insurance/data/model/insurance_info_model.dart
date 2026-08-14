import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_info.dart';

part 'insurance_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsuranceInfoModel {
  String? idProdutoCompl;
  String? idProduto;
  String? saibaMais;
  bool? ativo;
  String? termoDeUso;

  InsuranceInfoModel({
    this.idProdutoCompl,
    this.idProduto,
    this.saibaMais,
    this.ativo,
    this.termoDeUso,
  });

  factory InsuranceInfoModel.fromJson(dynamic json) =>
      _$InsuranceInfoModelFromJson(json);

  dynamic toJson() => _$InsuranceInfoModelToJson(this);

  static InsuranceInfoModel? fromEntity(InsuranceInfo? entity) => entity == null
      ? null
      : (InsuranceInfoModel()
        ..idProdutoCompl = entity.idProdutoCompl
        ..idProduto = entity.idProduto
        ..saibaMais = entity.saibaMais
        ..ativo = entity.ativo
        ..termoDeUso = entity.termoDeUso);

  InsuranceInfo toEntity() => InsuranceInfo()
    ..idProdutoCompl = this.idProdutoCompl
    ..idProduto = this.idProduto
    ..saibaMais = this.saibaMais
    ..ativo = this.ativo
    ..termoDeUso = this.termoDeUso;
}
