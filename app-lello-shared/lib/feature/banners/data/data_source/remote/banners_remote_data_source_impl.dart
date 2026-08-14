import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_api.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_remote_data_source.dart';
import 'package:shared_features/feature/banners/data/model/banner_model.dart';

class BannersRemoteDataSourceImpl extends BannersRemoteDataSource {
  final BannersApi api;
  BannersRemoteDataSourceImpl({required this.api});

  @override
  Future<List<BannerModel>> getBanners(String condominiumId) async {
    final response =
        await api.getBanners(condominiumId).timeout(Duration(seconds: 10));
    final result =
        ApiMapper.mapList(response, (json) => BannerModel.fromJson(json));
    result.forEach((element) {
      element.lastUpdateAt = DateTime.now();
    });
    return result;
  }
}
