import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:colaborador/feature/me/domain/repository/me_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:colaborador/feature/session/domain/repository/session_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class LogMeOutImpl extends LogMeOut {
  final AccessTokenRepository accessTokenRepository;
  final SessionRepository sessionRepository;
  final MeRepository meRepository;
  final LelloDatabase db;

  LogMeOutImpl({
    required this.accessTokenRepository,
    required this.sessionRepository,
    required this.meRepository,
    required this.db,
  });

  @override
  Future<Try<Nothing>> call() async {
    await accessTokenRepository.clear();
    await sessionRepository.clear();
    await meRepository.clear();
    await db.resetDb();
    return Success(Nothing());
  }
}
