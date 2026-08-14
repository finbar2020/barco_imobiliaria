import 'package:lello/feature/condominium/data/model/condominium_simple_model.dart';

abstract class CondominiumSimpleRemoteDataSource {
  Future<CondominiumSimpleModel> getSimple({required String condominiumId});
}
