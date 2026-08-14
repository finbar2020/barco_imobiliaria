import '../../feature/session/domain/entity/session.dart';

class SessionStore {
  Session? session;

  void setSession({required Session session}) {
    this.session = session;
  }

  void clear() {
    session = null;
  }
}
