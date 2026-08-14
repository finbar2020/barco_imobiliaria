import 'package:lello/feature/maintenance_management/data/model/condominium_info_model.dart';
import 'package:lello/feature/maintenance_management/data/model/condominium_tracking_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_token_model.dart';
import 'package:lello/feature/maintenance_management/data/model/tracking_trade_model.dart';
import 'package:lello/feature/maintenance_management/domain/entity/condominium_tracking_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_management_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_token_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/tracking_trade_entity.dart';

extension CondominiumInfoModelExtension on CondominiumInfoModel {
  CondominiumInfoEntity get toEntity {
    final tt = trackingTrade;
    final ttToken = tokens
        ?.where((t) => t.fornecedor?.toUpperCase() == 'TRACKING_TRADE')
        .map((t) => t.token)
        .whereType<String>()
        .firstOrNull;

    return CondominiumInfoEntity(
      id: id,
      assets: assets,
      floor: floor,
      localsCount: localsCount,
      workflowUsers: workflowUsers,
      condominiumName: condominiumName,
      blocksCount: blocksCount,
      unitsCount: unitsCount,
      references: references ?? [],
      condominium: condominium?.toEntity,
      trackingTrade: tt?.toEntity,
      tokens: tokens?.map((t) => t.toEntity).toList() ?? const [],
      // ── V2 fields derived from nested objects ──
      trackingTradeToken: ttToken,
      idSession: tt?.idSession,
      trackingTradeUserId: tt?.id,
      isAdmin: tt?.admin ?? false,
      trackingTradeStatus: tt?.status,
      trackingTradeImageUrl: tt?.imageUrl,
      profileId: tt?.profileId,
      hasEmployee: hasEmployee ?? false,
      hasTechnicalInspection: hasTechnicalInspection ?? false,
    );
  }
}

extension CondominiumTrackingModelExtension on CondominiumTrackingModel {
  CondominiumTrackingEntity get toEntity {
    return CondominiumTrackingEntity(
      idCondominiumTrackingTrade: idCondominiumTrackingTrade,
      idCondominiumLello: idCondominiumLello,
      reference: reference,
      statusCondominium: statusCondominium,
      condominiumName: condominiumName,
      idUserTracking: idUserTracking,
      idUserLello: idUserLello,
      statusUser: statusUser,
    );
  }
}

extension MaintenanceTokenModelExtension on MaintenanceTokenModel {
  MaintenanceTokenEntity get toEntity {
    return MaintenanceTokenEntity(
      fornecedor: fornecedor,
      token: token,
    );
  }
}

extension TrackingTradeModelExtension on TrackingTradeModel {
  TrackingTradeEntity get toEntity {
    return TrackingTradeEntity(
      id: id,
      idSession: idSession,
      username: username,
      status: status,
      admin: admin,
      profileId: profileId,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      invitationId: invitationId,
      lastPasswordUpdatedAt: lastPasswordUpdatedAt,
    );
  }
}
