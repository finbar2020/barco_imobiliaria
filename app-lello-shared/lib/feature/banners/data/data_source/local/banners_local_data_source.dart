import 'package:shared_features/feature/banners/data/model/banner_model.dart';

abstract class BannersLocalDataSource {
  Future<List<BannerModel>> select(String condominiumId);
  Future<List<BannerModel>?> save(
      List<BannerModel>? bannersModelList, String condominiumId);
}
