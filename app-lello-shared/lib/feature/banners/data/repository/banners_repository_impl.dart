import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_features/feature/banners/data/data_source/local/banners_local_data_source.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_remote_data_source.dart';
import 'package:shared_features/feature/banners/data/model/banner_model.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/repository/banners_repository.dart';

class BannersRepositoryImpl extends BannersRepository {
  final BannersRemoteDataSource remoteDataSource;
  final BannersLocalDataSource localDataSource;

  BannersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Try<List<BannerEntity>>> getBanners(String condominiumId) async {
    try {
      final result = await remoteDataSource.getBanners(condominiumId);
      localDataSource.save(result, condominiumId);
      List<BannerEntity> banners = _mapModelToEntity(result, condominiumId);
      return Success(banners);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<BannerEntity>>> selectFromCache(String condominiumId) async {
    try {
      final banners = await localDataSource.select(condominiumId);
      return Success(_mapModelToEntity(banners, condominiumId));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  List<BannerEntity> _mapModelToEntity(
      List<BannerModel> result, String condominiumId) {
    List<BannerEntity> banners =
        result.map((model) => model.toEntity()).toList();

    if (banners.length > 0) {
      banners.forEach((banner) {
        if (banner.image.isNotEmpty && banner.id.isNotEmpty) {
          banner.urlImage =
              "/condominiums/$condominiumId/banners/${banner.id}/image/${banner.image}";
        }
      });
    }
    return banners;
  }
}
