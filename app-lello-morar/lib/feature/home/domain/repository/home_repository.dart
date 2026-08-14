import 'package:morar/feature/home/domain/entity/home_banner.dart';
import 'package:essentials/essentials.dart';

abstract class HomeRepository {
  Future<Try<List<HomeBanner>>> getBanners(String condominiumId);
  Future<Try<String>> getLink(String unitId);
  Future<Try<String>> postTerms(String unitId);
}
