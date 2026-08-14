import 'package:essentials/essentials.dart';

part 'maintenance_token_model.g.dart';

@JsonSerializable()
class MaintenanceTokenModel {
  final String? fornecedor;
  final String? token;

  MaintenanceTokenModel({
    this.fornecedor,
    this.token,
  });

  factory MaintenanceTokenModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceTokenModelToJson(this);
}
