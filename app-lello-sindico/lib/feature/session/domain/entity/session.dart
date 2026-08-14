import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

class Session {
  Me? me;
  Condominium? selectedCondominium;
  ConsultantEntity? consultantEntity;

  Session();
}
