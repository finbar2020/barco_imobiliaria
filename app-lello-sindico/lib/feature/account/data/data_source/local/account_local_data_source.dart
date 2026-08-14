import 'package:lello/feature/account/data/model/account_model.dart';

abstract class AccountLocalDataSource {
	Future<List<AccountModel>> list(String condominiumId);
	Future<List<AccountModel>> save(String condominiumId, List<AccountModel> models);

}