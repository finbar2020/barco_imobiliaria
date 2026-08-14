import 'package:essentials/essentials.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/easy_fix/cnd/domain/entity/unit_profile_entity.dart';

abstract class CndPdfUseCase extends UseCase<DocumentFile, CndPdfParams> {}

class CndPdfParams {
  final String condominiumId;
  final UnitProfileEntity unitProfileEntity;

  CndPdfParams({required this.condominiumId, required this.unitProfileEntity});
}
