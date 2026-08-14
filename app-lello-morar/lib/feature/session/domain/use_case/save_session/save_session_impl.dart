import 'package:essentials/essentials.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/domain/repository/session_repository.dart';
import 'package:morar/feature/session/domain/use_case/save_session/save_session.dart';

class SaveSessionImpl extends SaveSession {
  final SessionRepository repository;

  SaveSessionImpl({required this.repository});

  @override
  Future<Try<Session>> call(Session params) async {
    final result = await repository.save(params);
    return result.fold((err) => Rejection(err), (data) => Success(params));
  }
}
