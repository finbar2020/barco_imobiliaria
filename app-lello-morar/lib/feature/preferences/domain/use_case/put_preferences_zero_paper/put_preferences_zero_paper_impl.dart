import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_zero_paper/put_preferences_zero_paper.dart';

class PutZeroPaperUseCaseImpl extends PutZeroPaperUseCase {
  final PreferencesRepository repository;

  PutZeroPaperUseCaseImpl({required this.repository});

  @override
  Future<Try<String>> call(PutZeroPaperParam params) async {
    final result = await repository.putPreferencesZeroPaper(params.entity);

    return result;
  }
}
