import 'package:essentials/essentials.dart';

part 'insurance_premium_value_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsurancePremiumValueModel {
  String idTitulo;
  String valor;

  InsurancePremiumValueModel({
    required this.idTitulo,
    required this.valor,
  });

  factory InsurancePremiumValueModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePremiumValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsurancePremiumValueModelToJson(this);
  factory InsurancePremiumValueModel.clone(InsurancePremiumValueModel value) =>
      InsurancePremiumValueModel(
        idTitulo: value.idTitulo,
        valor: value.valor,
      );
}
