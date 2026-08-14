import 'package:essentials/essentials.dart';

abstract class CheckDigitalPointUsecase
    extends UseCase<bool, CheckDigitalPointParam> {}

class CheckDigitalPointParam {
  final String condoId;
  final DateTime date;

  CheckDigitalPointParam({
    required this.condoId,
    required this.date,
  });
}
