import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/billets/data/data_source/billets_remote_data_source.dart';
import 'package:morar/feature/billets/domain/repository/billets_repository.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

class BilletsRepositoryImpl extends BilletsRepository {
  final BilletsRemoteDataSource dataSource;

  BilletsRepositoryImpl({required this.dataSource});

  @override
  Future<Try<Paginator>> getBillets(String reference, String unitId,
      {bool showAll = false}) async {
    try {
      final data =
          await dataSource.getBillets(reference, unitId, showAll: showAll);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'reference: $reference - unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<DocumentFile>> getPdf(String nrBillet) async {
    try {
      final data = await dataSource.getBilletPdf(nrBillet);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'nrBillet: $nrBillet',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
