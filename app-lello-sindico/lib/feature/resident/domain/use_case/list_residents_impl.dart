import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';

class ListResidentsImpl extends ListResidents {
  final ResidentRepository repository;

  ListResidentsImpl({required this.repository});

  @override
  Future<Try<List<Resident>>> call(ListResidentsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.list(params.origin, params.condominiumId,
        lastResidentId: params.lastResidentId,
        query: params.query,
        loadAll: params.loadAll ?? false);
    return result;
  }

  Failure? validate(ListResidentsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
