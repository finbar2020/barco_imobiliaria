import 'package:essentials/essentials.dart';

abstract class GetPaydayUseCase extends UseCase<List<String>, GetPaydayParams> {
}

class GetPaydayParams {
  final String condoId;

  GetPaydayParams({required this.condoId});
}
