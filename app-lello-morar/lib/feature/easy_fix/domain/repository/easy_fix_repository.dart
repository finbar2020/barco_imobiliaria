import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

abstract class EasyFixRepository {
  Future<Try<EasyFixUnit>> getEasyFixUnit({required String condominiumId});
  Future<Try<void>> updateAddress({
    required String condominiumId,
    required EasyFixUnit unit,
  });
  Future<Try<List<City>>> getCities({
    required String condominiumId,
    required String uf,
  });
}
