import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_pdf_entity.dart';

abstract class IaBellaPdfUseCase
    extends UseCase<IaBellaPdfEntity, IaBellaPdfParam> {}

class IaBellaPdfParam {
  final String condominiumId;
  final String documentId;
  final String serviceType;

  IaBellaPdfParam(
      {required this.condominiumId,
      required this.documentId,
      required this.serviceType});
}
