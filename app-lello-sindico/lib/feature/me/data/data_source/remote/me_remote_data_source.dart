import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/data/model/me_password_model.dart';

abstract class MeRemoteDataSource {
	Future<MeModel> get();
	Future<MeModel> patch(MeModel me, String code);
	Future updatePassword(MePasswordModel model);
}