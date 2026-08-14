import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';

abstract class ChangePartnerFavoriteStatusUseCase
    extends UseCase<ComfortPartnerFavorite, ChangePartnerFavoriteStatusParam> {}

class ChangePartnerFavoriteStatusParam {
  String condominiumId;
  String partnerId;
  bool isFavorite;
  ChangePartnerFavoriteStatusParam({
    required this.condominiumId,
    required this.partnerId,
    required this.isFavorite,
  });
}
