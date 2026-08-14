import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/get_spaces/get_spaces.dart';

class GetSpaceImpl extends GetSpace {
  final ReservationRepository repository;

  GetSpaceImpl({required this.repository});

  @override
  Future<Try<List<Space>>> call(GetSpaceParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getSpaces(params.condominiumId);

    return result;
  }

  Failure? validate(GetSpaceParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
