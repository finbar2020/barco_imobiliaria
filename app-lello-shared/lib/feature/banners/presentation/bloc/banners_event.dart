
import 'package:shared_features/feature/banners/domain/entity/banner.dart';

abstract class BannersEvent {}

class BannersLoadingEvent extends BannersEvent {}

class BannersLoadedEvent extends BannersEvent {
  List<BannerEntity> banners;

  BannersLoadedEvent({required this.banners});
}

class BannersErrorEvent extends BannersEvent {}
