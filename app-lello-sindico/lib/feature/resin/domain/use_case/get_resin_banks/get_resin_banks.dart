import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';

abstract class GetResinBanks
    extends UseCase<List<ResinBank>, GetResinBanksParams> {}

class GetResinBanksParams {
  final String condominiumId;
  final DataOrigin origin;

  GetResinBanksParams({
    required this.condominiumId,
    required this.origin,
  });
}
