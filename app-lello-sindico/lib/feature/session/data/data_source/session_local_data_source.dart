import 'package:lello/feature/session/data/model/session_model.dart';

abstract class SessionLocalDataSource {
  Future<SessionModel?> select();
  Future<SessionModel?> save(SessionModel? model);
}
