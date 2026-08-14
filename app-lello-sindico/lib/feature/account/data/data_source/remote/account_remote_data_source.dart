import 'package:lello/feature/account/data/model/account_model.dart';

abstract class AccountRemoteDataSource {
	Future<List<AccountModel>> list(String condominiumId);
}