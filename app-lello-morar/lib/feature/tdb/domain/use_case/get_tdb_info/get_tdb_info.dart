import 'package:essentials/essentials.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';

abstract class GetTDBInfoUseCase extends UseCase<TDBInfo, GetTDBInfoParam> {}

class GetTDBInfoParam {
  String condominiumId;
  GetTDBInfoParam({
    required this.condominiumId,
  });
}
