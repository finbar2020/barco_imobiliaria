import 'package:morar/feature/home/data/data_source/home_api.dart';
import 'package:morar/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:morar/feature/home/data/model/home_banner_model.dart';

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final HomeApi api;

  HomeRemoteDataSourceImpl({required this.api});

  @override
  Future<List<HomeBannerModel>> getBanners(
    String condominiumId,
  ) async {
    // final response = await api.getBanners(condominiumId);
    // return ApiMapper.mapList(
    //     response, (json) => HomeBannerModel.fromJson(json));
    // await Future.delayed(Duration(seconds: 3));
    return [
      HomeBannerModel(
        insideApp: false,
        url: "",
        image: "assets/banner_casa_protegida.png",
      ),
      HomeBannerModel(
        insideApp: false,
        url: "",
        image: "assets/banner_parafuzo.png",
      ),
      HomeBannerModel(
        insideApp: false,
        url: "",
        image: "assets/banner_lavaemcasa.png",
      ),
      // HomeBannerModel(
      //   insideApp: false,
      //   url: "",
      //   image: "assets/banner_club_lello.png",
      // ),
    ];
  }

  @override
  Future<String> getLink(String unitId) async {
    final response = await api.getLink(unitId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return response.body;
    }
  }

  @override
  Future<String> postTerms(String unitId) async {
    final response = await api.postTerms(unitId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return response.body;
    }
  }
}
