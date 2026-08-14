import 'package:essentials/essentials.dart';
import 'package:morar/feature/session/data/data_source/session_local_data_source.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/domain/repository/session_repository.dart';

class SessionRepositoryImpl extends SessionRepository {
  final SessionLocalDataSource sessionDataSource;

  SessionRepositoryImpl({required this.sessionDataSource});

  @override
  Future<Try<SessionModel?>> save(Session session) async {
    try {
      final model = SessionModel.fromEntity(session);
      final result = await sessionDataSource.save(model);
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<SessionModel?>> select() async {
    try {
      final model = await sessionDataSource.select();
      return Success(model);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Nothing>> clear() async {
    try {
      await sessionDataSource.save(null);
      return Success(Nothing());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
