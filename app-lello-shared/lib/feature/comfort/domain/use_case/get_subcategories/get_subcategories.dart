import 'package:essentials/base/use_case.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';

abstract class GetSubcategoriesUseCase
    extends UseCase<List<ComfortSubcategories>, GetSubcategoriesUseCaseParam> {}

class GetSubcategoriesUseCaseParam {
  String condominiumId;
  GetSubcategoriesUseCaseParam({required this.condominiumId});
}
