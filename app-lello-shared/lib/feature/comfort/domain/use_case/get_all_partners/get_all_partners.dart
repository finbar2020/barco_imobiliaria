import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';

abstract class GetAllPartnersUseCase
    extends UseCase<List<ComfortPartner>, GetAllPartnersParam> {}

class GetAllPartnersParam {
  String condominiumId;
  GetAllPartnersParam({required this.condominiumId});
}
