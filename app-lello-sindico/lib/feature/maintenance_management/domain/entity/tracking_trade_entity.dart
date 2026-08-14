import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';

class TrackingTradeEntity {
  final String? id;
  final String? idSession;
  final String? username;
  final TrackingTradeStatus? status;
  final bool? admin;
  final String? profileId;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? invitationId;
  final String? lastPasswordUpdatedAt;

  const TrackingTradeEntity({
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
}
