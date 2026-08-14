import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class FindSupplier
    extends UseCase<List<SupplierDataEntity>, FindSupplierParam> {}

class FindSupplierParam {
  final String condominiumId;
  final String? name;
  final String? document;

  FindSupplierParam({
    required this.condominiumId,
    this.name,
    this.document,
  });
}
