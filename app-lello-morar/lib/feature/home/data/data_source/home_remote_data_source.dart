import 'package:morar/feature/home/data/model/home_banner_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeBannerModel>> getBanners(String condominiumId);
  Future<String> getLink(String unitId);
  Future<String> postTerms(String unitId);
}
