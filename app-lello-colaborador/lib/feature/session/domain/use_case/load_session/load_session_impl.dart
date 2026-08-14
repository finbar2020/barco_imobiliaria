import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/domain/repository/session_repository.dart';
import 'package:colaborador/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:essentials/essentials.dart';

class LoadSessionImpl extends LoadSession {
  final GetMe getMe;
  final SessionRepository repository;

  LoadSessionImpl({required this.getMe, required this.repository});

  @override
  Future<Try<Session>> call(DataOrigin origin) async {
    final meFuture = getMe.call(origin);
    final sessionFuture = repository.select();

    final results =
        await Future.wait([meFuture, sessionFuture], eagerError: true);

    final meResult = results[0];
    final sessionResult = results[1];

    if (origin == DataOrigin.remote && meResult is Rejection) {
      return Rejection(meResult.get());
    }

    Me? me = meResult.fold<Me?>((error) => null, (data) {
      if (data is Me) {
        return data;
      }
      return null;
    });

    if (me == null) {
      return Rejection(KnownFailure("me_not_found", null));
    }
    if (me.condominiums.isEmpty) {
      return Rejection(KnownFailure("condominium_not_found", null));
    }
    Session result = Session(me: me, condominium: me.condominiums.first);

    if (sessionResult is Success<SessionModel?>) {
      sessionResult.get()?.toEntity();

      // if (result.me.condominium == null) {
      //   return Rejection(KnownFailure("condominium_not_found", null));
      // }
    }

    return Success(result);
  }
}
