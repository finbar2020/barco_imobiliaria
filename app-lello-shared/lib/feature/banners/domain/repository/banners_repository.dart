import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';

abstract class BannersRepository {
  Future<Try<List<BannerEntity>>> getBanners(String condominiumId);
  Future<Try<List<BannerEntity>>> selectFromCache(String condominiumId);
}
