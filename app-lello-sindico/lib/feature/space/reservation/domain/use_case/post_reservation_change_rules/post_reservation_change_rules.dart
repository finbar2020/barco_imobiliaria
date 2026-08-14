import 'package:essentials/essentials.dart';

abstract class PostReservationChangeRules
    extends UseCase<String, PostReservationChangeRulesParam> {}

class PostReservationChangeRulesParam {
  final String condominiumId;
  final Map<String, dynamic> body;

  PostReservationChangeRulesParam(
      {required this.condominiumId, required this.body});
}
