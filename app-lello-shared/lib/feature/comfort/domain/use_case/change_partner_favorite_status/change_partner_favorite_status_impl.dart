import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status.dart';

class ChangePartnerFavoriteStatusUseCaseImpl
    extends ChangePartnerFavoriteStatusUseCase {
  final ComfortRepository repository;

  ChangePartnerFavoriteStatusUseCaseImpl({required this.repository});

  @override
  Future<Try<ComfortPartnerFavorite>> call(
      ChangePartnerFavoriteStatusParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.changePartnerFavoriteStatus(
        params.condominiumId, params.partnerId, params.isFavorite);

    return result;
  }

  Failure? validate(ChangePartnerFavoriteStatusParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.partnerId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
