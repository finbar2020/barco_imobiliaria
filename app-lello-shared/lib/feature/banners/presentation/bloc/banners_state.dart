
import 'package:shared_features/feature/banners/domain/entity/banner.dart';

abstract class BannersState {}

class EmptyBannersState extends BannersState {}

class LoadingBannersState extends BannersState {}

class ErrorBannersState extends BannersState {}

class LoadedBannersState extends BannersState {
  List<BannerEntity> banners;

  LoadedBannersState({required this.banners});
}
