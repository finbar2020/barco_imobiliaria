import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';

abstract class ListAccounts extends UseCase<List<Account>, ListAccountsParms> {}

class ListAccountsParms {
  final DataOrigin origin;
  final String condominiumId;
  ListAccountsParms({required this.origin, required this.condominiumId});
}
