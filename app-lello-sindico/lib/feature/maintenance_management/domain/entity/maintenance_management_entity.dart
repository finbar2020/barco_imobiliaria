
import 'condominium_tracking_entity.dart';
import 'maintenance_token_entity.dart';
import '../enum/tracking_trade_status.dart';
import 'tracking_trade_entity.dart';

class CondominiumInfoEntity {
  // ── Campos V1 (mantidos para compatibilidade retroativa) ─────────────────
  final String id;
  final int assets;
  final String floor;
  final int localsCount;
  final String workflowUsers;
  final String condominiumName;
  final int blocksCount;
  final int unitsCount;
  final List<int> references;

  // ── Campos V2 ────────────────────────────────────────────────────────────
  /// Token do fornecedor TRACKING_TRADE (`tokens[fornecedor=="TRACKING_TRADE"].token`).
  final String? trackingTradeToken;

  /// ID da sessão no TrackingTrade (`trackingTrade.idSession`).
  final String? idSession;

  /// ID do usuário no TrackingTrade (`trackingTrade.id`).
  final String? trackingTradeUserId;

  /// Se o usuário é administrador no TrackingTrade (`trackingTrade.admin`).
  final bool isAdmin;

  /// Status do usuário no TrackingTrade (`trackingTrade.status`).
  final TrackingTradeStatus? trackingTradeStatus;

  /// URL do avatar do usuário no TrackingTrade (`trackingTrade.imageUrl`).
  final String? trackingTradeImageUrl;

  /// Perfil do usuário no TrackingTrade (`trackingTrade.profileId`).
  ///
  /// Exemplos: `sindico.full`, `sindicopreposto.full`, `consultor.full`.
  final String? profileId;
  final CondominiumTrackingEntity? condominium;
  final TrackingTradeEntity? trackingTrade;
  final List<MaintenanceTokenEntity> tokens;

  /// Whether the condominium has registered employees (from upstream v2).
  final bool hasEmployee;

  /// Whether the condominium has technical inspection obligations (from upstream v2).
  final bool hasTechnicalInspection;

  const CondominiumInfoEntity({
    required this.id,
    required this.assets,
    required this.floor,
    required this.localsCount,
    required this.workflowUsers,
    required this.condominiumName,
    required this.blocksCount,
    required this.unitsCount,
    required this.references,
    // V2 — opcionais para manter compat. com factory do BLoC e V1
    this.trackingTradeToken,
    this.idSession,
    this.trackingTradeUserId,
    this.isAdmin = false,
    this.trackingTradeStatus,
    this.trackingTradeImageUrl,
    this.profileId,
    this.condominium,
    this.trackingTrade,
    this.tokens = const [],
    this.hasEmployee = false,
    this.hasTechnicalInspection = false,
  });

  /// `true` quando o condom�nio possui pelo menos um token de integra��o.
  bool get hasTokens => tokens.isNotEmpty;

  bool get isTrackingTradeActive =>
      trackingTradeStatus == TrackingTradeStatus.active;
}
