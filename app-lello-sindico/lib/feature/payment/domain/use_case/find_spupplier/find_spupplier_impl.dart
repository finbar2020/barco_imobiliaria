import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/find_spupplier/find_spupplier.dart';

class FindSupplierImpl extends FindSupplier {
  final PaymentRepository repository;

  FindSupplierImpl({required this.repository});

  @override
  Future<Try<List<SupplierDataEntity>>> call(FindSupplierParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.findSupplier(
        params.condominiumId, params.name, params.document);
  }

  Failure? _validate(FindSupplierParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
