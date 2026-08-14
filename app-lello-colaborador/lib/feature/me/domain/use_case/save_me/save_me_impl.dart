import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/repository/me_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me_failure.dart';
import 'package:essentials/essentials.dart';

class SaveMeImpl extends SaveMe {
  final MeRepository repository;

  SaveMeImpl({required this.repository});

  @override
  Future<Try<Me?>> call(SaveMeParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    var result =
        await repository.save(params.me!, params.codeValidation?.id ?? "");
    return result;
  }

  Failure? validate(SaveMeParam params) {
    if (params.me == null) return InvalidParamFailure();
    if (params.originalMe == null) return InvalidParamFailure();
    if (params.me!.phone != params.originalMe!.phone &&
        params.codeValidation == null) {
      return SaveMeInvalidCodeValidationFailure();
    }
    return null;
  }
}
