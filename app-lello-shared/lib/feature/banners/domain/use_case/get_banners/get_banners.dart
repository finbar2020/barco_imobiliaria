import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';

abstract class GetBannersUseCase
    extends UseCase<List<BannerEntity>, GetBannersParam> {}

class GetBannersParam {
  final String condominiumId;
  final DataOrigin origin;
  GetBannersParam({required this.condominiumId, required this.origin});
}
