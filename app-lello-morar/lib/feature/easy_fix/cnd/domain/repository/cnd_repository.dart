import 'package:essentials/essentials.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/easy_fix/cnd/domain/entity/unit_profile_entity.dart';

abstract class CndRepository {
  Future<Try<DocumentFile>> generateCertificateNoOutstandingDebt(
      String condominiumId, UnitProfileEntity unitProfileEntity);
}
