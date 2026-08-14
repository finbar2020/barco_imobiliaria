import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';

abstract class UpdatePendency
    extends UseCase<List<Pendency>, UpdatePendencyParam> {}

class UpdatePendencyParam {
  final String condominiumId;
  final String pendencyId;

  UpdatePendencyParam(this.condominiumId, this.pendencyId);
}
