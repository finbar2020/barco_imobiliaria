import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/repository/account_repository.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';

class ListAccountsImpl extends ListAccounts {
  final AccountRepository repository;

  ListAccountsImpl({required this.repository});
  @override
  Future<Try<List<Account>>> call(ListAccountsParms params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.origin, params.condominiumId);
  }

  Failure? validate(ListAccountsParms params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
