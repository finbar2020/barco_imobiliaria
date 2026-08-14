import 'package:essentials/essentials.dart';

import 'package:lello/feature/account/domain/entity/account.dart';

abstract class AccountRepository {
  Future<Try<List<Account>>> list(DataOrigin origin, String condominiumId);
}
