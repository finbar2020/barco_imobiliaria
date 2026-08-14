import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/repository/home_repository.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go.dart';

class HomeToGoImpl extends HomeToGo {
  final HomeRepository repository;

  HomeToGoImpl({required this.repository});

  @override
  Future<Try<String>> call(HomeToGoParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getLink(params.unitId);
  }

  Failure? _validate(HomeToGoParams param) {
    if (param.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
