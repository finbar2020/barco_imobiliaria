import 'package:essentials/essentials.dart';

import 'condominium_tracking_model.dart';
import 'maintenance_token_model.dart';
import 'tracking_trade_model.dart';

part 'condominium_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CondominiumInfoModel {
  String id;
  int assets;
  String floor;
  int localsCount;
  String workflowUsers;
  String condominiumName;
  int blocksCount;
  int unitsCount;
  List<int>? references;
  CondominiumTrackingModel? condominium;
  TrackingTradeModel? trackingTrade;
  List<MaintenanceTokenModel>? tokens;
  bool? hasEmployee;
  bool? hasTechnicalInspection;

  CondominiumInfoModel({
    required this.id,
    required this.assets,
    required this.floor,
    required this.localsCount,
    required this.workflowUsers,
    required this.condominiumName,
    required this.blocksCount,
    required this.unitsCount,
    this.references,
    this.condominium,
    this.trackingTrade,
    this.tokens,
    this.hasEmployee,
    this.hasTechnicalInspection,
  });

  factory CondominiumInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CondominiumInfoModelToJson(this);
}
