import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class GetSupplier
    extends UseCase<SupplierDataEntity, GetSupplierParam> {}

class GetSupplierParam {
  final String condominiumId;
  final String id;

  GetSupplierParam({
    required this.condominiumId,
    required this.id,
  });
}
