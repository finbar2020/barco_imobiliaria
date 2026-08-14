import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners.dart';

class GetAllPartnersUseCaseImpl extends GetAllPartnersUseCase {
  final ComfortRepository repository;

  GetAllPartnersUseCaseImpl({required this.repository});

  @override
  Future<Try<List<ComfortPartner>>> call(GetAllPartnersParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getAllPartners(params.condominiumId);

    return result;
  }

  Failure? validate(GetAllPartnersParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
