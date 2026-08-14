import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space.dart';

class RegisterSpaceImpl extends RegisterSpace {
  final SpaceRepository repository;

  RegisterSpaceImpl({required this.repository});
  @override
  Future<Try<Space>> call(RegisterSpaceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insert(params.condominiumId, params.space);
  }

  Failure? _validate(RegisterSpaceParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
