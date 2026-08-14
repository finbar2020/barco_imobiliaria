import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/repository/banners_repository.dart';
import 'package:shared_features/feature/banners/domain/use_case/get_banners/get_banners.dart';

class GetBannersUseCaseImpl extends GetBannersUseCase {
  final BannersRepository repository;

  GetBannersUseCaseImpl({required this.repository});

  @override
  Future<Try<List<BannerEntity>>> call(GetBannersParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = params.origin == DataOrigin.remote
        ? await repository.getBanners(params.condominiumId)
        : await repository.selectFromCache(params.condominiumId);

    return result;
  }

  Failure? validate(GetBannersParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
