import 'package:lello/feature/me/data/model/me_model.dart';

abstract class MeLocalDataSource {
  Future<MeModel?> select();
  Future<MeModel?> save(MeModel? model);
}
