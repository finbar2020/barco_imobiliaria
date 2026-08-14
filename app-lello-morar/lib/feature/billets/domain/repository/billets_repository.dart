import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';

abstract class BilletsRepository {
  Future<Try<Paginator>> getBillets(String reference, String unitId,
      {bool showAll = false});
  Future<Try<DocumentFile>> getPdf(String nrBillet);
}
