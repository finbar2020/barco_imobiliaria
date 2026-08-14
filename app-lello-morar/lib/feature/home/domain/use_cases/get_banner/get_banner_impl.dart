import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';
import 'package:morar/feature/home/domain/repository/home_repository.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner.dart';

class GetBannerImpl extends GetBanner {
  final HomeRepository repository;

  GetBannerImpl({required this.repository});

  @override
  Future<Try<List<HomeBanner>>> call(GetBannerParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getBanners(params.condominuimId);
  }

  Failure? _validate(GetBannerParams param) {
    if (param.condominuimId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
