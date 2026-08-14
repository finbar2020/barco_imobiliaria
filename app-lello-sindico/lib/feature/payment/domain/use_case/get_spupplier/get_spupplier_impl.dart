import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier.dart';

class GetSupplierImpl extends GetSupplier {
  final PaymentRepository repository;

  GetSupplierImpl({required this.repository});

  @override
  Future<Try<SupplierDataEntity>> call(GetSupplierParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getSupplier(params.condominiumId, params.id);
  }

  Failure? _validate(GetSupplierParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
