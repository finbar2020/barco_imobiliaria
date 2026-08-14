import 'package:essentials/essentials.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session.dart';

class SaveSessionImpl extends SaveSession {
  final SessionRepository repository;

  SaveSessionImpl({required this.repository});

  @override
  Future<Try<Session>> call(Session params) async {
    Failure? error = validate(params);
    if (error != null) {
      return Rejection(error);
    }

    final result = await repository.save(params);
    return result.fold((err) => Rejection(err), (data) => Success(params));
  }

  Failure? validate(Session? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
