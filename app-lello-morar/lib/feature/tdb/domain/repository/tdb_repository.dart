import 'package:essentials/essentials.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';

abstract class TDBRepository {
  Future<Try<TDBInfo>> getTDBInfo(String condominiumId);
}
