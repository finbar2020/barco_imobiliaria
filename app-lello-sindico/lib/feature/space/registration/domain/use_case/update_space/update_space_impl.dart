import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space.dart';

class UpdateSpaceImpl extends UpdateSpace {
  final SpaceRepository repository;

  UpdateSpaceImpl({required this.repository});
  @override
  Future<Try<Space>> call(UpdateSpaceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.update(params.condominiumId, params.space);
  }

  Failure? _validate(UpdateSpaceParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
