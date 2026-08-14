import 'package:essentials/essentials.dart';

part 'condominium_tracking_model.g.dart';

@JsonSerializable()
class CondominiumTrackingModel {
  final String? idCondominiumTrackingTrade;
  final int? idCondominiumLello;
  final int? reference;
  final String? statusCondominium;
  final String? condominiumName;
  final String? idUserTracking;
  final int? idUserLello;
  final String? statusUser;

  CondominiumTrackingModel({
    this.idCondominiumTrackingTrade,
    this.idCondominiumLello,
    this.reference,
    this.statusCondominium,
    this.condominiumName,
    this.idUserTracking,
    this.idUserLello,
    this.statusUser,
  });

  factory CondominiumTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumTrackingModelFromJson(json);

  Map<String, dynamic> toJson() => _$CondominiumTrackingModelToJson(this);
}
