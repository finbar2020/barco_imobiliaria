import 'package:lello/feature/consultant_lello/data/model/consultant_lello_model.dart';

abstract class ConsultantRemoteDataSource {
	Future<ConsultantModel> consultant(String condominiumId);
}