import 'package:essentials/essentials.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_remote_data_source.dart';
import 'package:morar/feature/easy_fix/cnd/data/model/unit_profile_model.dart';
import 'package:morar/feature/easy_fix/cnd/domain/entity/unit_profile_entity.dart';
import 'package:morar/feature/easy_fix/cnd/domain/repository/cnd_repository.dart';

class CndRepositoryImpl extends CndRepository {
  final CndRemoteDataSource dataSource;

  CndRepositoryImpl({required this.dataSource});

  @override
  Future<Try<DocumentFile>> generateCertificateNoOutstandingDebt(
      String condominiumId, UnitProfileEntity unitProfileEntity) async {
    try {
      final data = await dataSource.generateCertificateNoOutstandingDebt(
          condominiumId: condominiumId,
          model: UnitProfileModel.fromEntity(unitProfileEntity));
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      if (e is ApiFailure) {
        print(e.status);
        switch (e.status) {
          case 409:
            return Rejection(
              KnownFailure(
                  e.detail ??
                      e.failure?.toString() ??
                      "easy_fix_has_outstanding_debt",
                  e),
            );
          default:
            FirebaseCrashlytics.instance.recordError(
              e,
              stacktrace,
              reason: 'condominiumId: $condominiumId',
            );
            return Rejection(
              UnknownFailure(e),
            );
        }
      } else {
        FirebaseCrashlytics.instance.recordError(
          e,
          stacktrace,
          reason: 'condominium Id: $condominiumId',
        );
        return Rejection(
          UnknownFailure(e),
        );
      }
    }
  }
}
