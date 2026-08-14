import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:essentials/essentials.dart';

abstract class SessionRepository {
  Future<Try<SessionModel?>> select();
  Future<Try<SessionModel?>> save(Session? session);
  Future<Try<Nothing>> clear();
}
