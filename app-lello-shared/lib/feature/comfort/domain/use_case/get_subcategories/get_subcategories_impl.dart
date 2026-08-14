import 'package:essentials/essentials.dart';
import 'package:essentials/functional/try.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories.dart';

class GetSubcategoriesUseCaseImpl extends GetSubcategoriesUseCase {
  final ComfortRepository repository;

  GetSubcategoriesUseCaseImpl({required this.repository});

  @override
  Future<Try<List<ComfortSubcategories>>> call(
      GetSubcategoriesUseCaseParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.getSubcategories(params.condominiumId);
    return result;

  }

  Failure? validate(GetSubcategoriesUseCaseParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
