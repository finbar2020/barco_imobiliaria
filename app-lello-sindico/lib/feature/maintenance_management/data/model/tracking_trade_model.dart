import 'package:essentials/essentials.dart';
import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';

part 'tracking_trade_model.g.dart';

@JsonSerializable()
class TrackingTradeModel {
  final String? id;
  final String? idSession;
  final String? username;
  @JsonKey(fromJson: _trackingTradeStatusFromJson, toJson: _trackingTradeStatusToJson)
  final TrackingTradeStatus? status;
  final bool? admin;
  final String? profileId;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? invitationId;
  final String? lastPasswordUpdatedAt;

  const TrackingTradeModel({
    this.id,
    this.idSession,
    this.username,
    this.status,
    this.admin,
    this.profileId,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.invitationId,
    this.lastPasswordUpdatedAt,
  });

  factory TrackingTradeModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingTradeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingTradeModelToJson(this);
}

TrackingTradeStatus? _trackingTradeStatusFromJson(String? value) {
  return TrackingTradeStatusExtension.fromApiValue(value);
}

String? _trackingTradeStatusToJson(TrackingTradeStatus? status) {
  return status?.apiValue;
}
