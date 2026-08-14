import 'package:shared_features/feature/banners/data/model/banner_model.dart';

abstract class BannersRemoteDataSource {
  Future<List<BannerModel>> getBanners(String condominiumId);
}
