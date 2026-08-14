import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';

abstract class IaBellaSendMessageUseCase
    extends UseCase<IaBellaDataEntity, IaBellaSendMessageParam> {}

class IaBellaSendMessageParam {
  final String condominiumId;
  IaBellaSendMessageModel userInput;

  IaBellaSendMessageParam(
      {required this.condominiumId, required this.userInput});
}
