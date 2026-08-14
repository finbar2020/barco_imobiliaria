import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_remote_data_source.dart';
import 'package:morar/feature/mailing/domain/repository/mailing_repository.dart';

class MailingRepositoryImpl extends MailingRepository {
  final MailingRemoteDataSource dataSource;

  MailingRepositoryImpl({required this.dataSource});

  @override
  Future<Try<Paginator>> getMailings(String unityId,
      {bool showAll = false}) async {
    try {
      final data = await dataSource.getMailings(unityId, showAll: showAll);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unityId: $unityId - showAll: $showAll',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<Uint8List?>> getPicture(String hash) async {
    try {
      final data = await dataSource.getPicture(hash);

      return Success(data);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'hash: $hash',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
