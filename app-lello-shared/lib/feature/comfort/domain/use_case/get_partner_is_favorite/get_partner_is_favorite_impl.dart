import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite.dart';

class GetPartnerIsFavoriteUseCaseImpl extends GetPartnerIsFavoriteUseCase {
  final ComfortRepository repository;

  GetPartnerIsFavoriteUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortPartnerFavorite>> call(
      GetPartnerIsFavoriteParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getPartnerIsFavorite(
        params.condominiumId, params.partnerId);

    return result;
  }

  Failure? validate(GetPartnerIsFavoriteParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.partnerId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
