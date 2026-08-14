import 'package:essentials/essentials.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

abstract class BilletsPdfUseCase
    extends UseCase<DocumentFile, BilletsPdfParams> {}

class BilletsPdfParams {
  final String nrBillet;

  BilletsPdfParams({required this.nrBillet});
}
