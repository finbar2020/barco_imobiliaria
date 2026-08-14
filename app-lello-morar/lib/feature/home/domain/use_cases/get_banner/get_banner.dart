import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';

abstract class GetBanner extends UseCase<List<HomeBanner>, GetBannerParams> {}

class GetBannerParams {
  final String condominuimId;

  GetBannerParams({required this.condominuimId});
}
