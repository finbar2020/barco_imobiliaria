import 'package:essentials/essentials.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:morar/feature/session/domain/entity/session.dart';

abstract class SessionRepository {
  Future<Try<SessionModel?>> select();
  Future<Try<SessionModel?>> save(Session session);
  Future<Try<Nothing>> clear();
}
