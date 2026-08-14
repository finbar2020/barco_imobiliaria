import 'package:shared_features/core/database/banners/banners_args_dao.dart';
import 'package:shared_features/core/database/banners/banners_args_hive_model.dart';
import 'package:shared_features/core/database/banners/banners_dao.dart';
import 'package:shared_features/core/database/banners/banners_hive_model.dart';
import 'package:shared_features/feature/banners/data/model/banner_args_model.dart';

import 'package:shared_features/feature/banners/data/data_source/local/banners_local_data_source.dart';
import 'package:shared_features/feature/banners/data/model/banner_model.dart';

class BannersLocalDataSourceImpl extends BannersLocalDataSource {
  final BannersDao bannersDao;
  final BannersArgsDao argsDao;

  BannersLocalDataSourceImpl({
    required this.bannersDao,
    required this.argsDao,
  });

  @override
  Future<List<BannerModel>?> save(
      List<BannerModel>? banners, String condominiumId) async {
    await bannersDao.clear(condominiumId);
    await argsDao.clearByCondominium(condominiumId);

    if (banners == null) return null;

    for (BannerModel banner in banners) {
      final bannerData = BannersHive()
        ..id = banner.id
        ..condominiumId = condominiumId
        ..redirect = banner.redirect
        ..redirectType = banner.redirectType
        ..image = banner.image
        ..urlImage = banner.urlImage
        ..feature = banner.feature
        ..location = banner.location
        ..name = banner.name
        ..observacao = banner.observacao
        ..subTitle = banner.subTitle
        ..typeBanner = banner.typeBanner
        ..projeto = banner.projeto
        ..ordem = banner.ordem
        ..ativo = banner.ativo
        ..lastUpdateAt = DateTime.now();

      final bannerArg = BannersArgsHiveModel()
        ..bannerId = banner.id
        ..condominiumId = condominiumId
        ..partnerId = banner.arg?.partnerId;

      await bannersDao.insert(bannerData);
      await argsDao.insert(bannerArg);
    }
    return banners;
  }

  @override
  Future<List<BannerModel>> select(String condominiumId) async {
    final bannersData = await bannersDao.get(condominiumId);
    final bannersArgsData = await argsDao.getByCondominiumId(condominiumId);

    if (bannersData.isEmpty) return [];

    List<BannerModel> banners = [];

    bannersData.forEach((element) {
      BannersArgsHiveModel? argsData;
      int index =
          bannersArgsData.indexWhere((arg) => arg.bannerId == element.id);
      if (index > -1) {
        argsData = bannersArgsData[index];
      }
      final BannerModel banner = BannerModel(
        id: element.id,
        redirect: element.redirect,
        redirectType: element.redirectType,
        name: element.name,
        observacao: element.observacao,
        image: element.image,
        urlImage: element.urlImage,
        feature: element.feature,
        location: element.location,
        subTitle: element.subTitle,
        typeBanner: element.typeBanner,
        projeto: element.projeto,
        ordem: element.ordem,
        ativo: element.ativo,
        arg: argsData == null
            ? null
            : BannerArgsModel(partnerId: argsData.partnerId),
        lastUpdateAt: element.lastUpdateAt,
      );
      banners.add(banner);
    });

    return banners;
  }
}
