import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';

abstract class GetPartnerIsFavoriteUseCase
    extends UseCase<ComfortPartnerFavorite, GetPartnerIsFavoriteParam> {}

class GetPartnerIsFavoriteParam {
  String condominiumId;
  String partnerId;
  GetPartnerIsFavoriteParam({
    required this.condominiumId,
    required this.partnerId,
  });
}
