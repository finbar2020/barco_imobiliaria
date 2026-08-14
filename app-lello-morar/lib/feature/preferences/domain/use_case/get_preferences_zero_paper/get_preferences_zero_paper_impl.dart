import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';
import 'package:morar/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_zero_paper/get_preferences_zero_paper.dart';

class GetZeroPaperUseCaseImpl extends GetZeroPaperUseCase {
  final PreferencesRepository repository;

  GetZeroPaperUseCaseImpl({required this.repository});

  @override
  Future<Try<PreferencesZeroPaperEntity>> call(GetZeroPaperParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);
    final result = await repository.getPreferencesZeroPaper();

    return result;
  }

  Failure? validate(GetZeroPaperParam params) {
    if (params.unityId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
