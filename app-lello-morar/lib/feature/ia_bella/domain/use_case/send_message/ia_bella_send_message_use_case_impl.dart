import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case.dart';

class IaBellaSendMessageUseCaseImpl extends IaBellaSendMessageUseCase {
  final IaBellaRepository repository;

  IaBellaSendMessageUseCaseImpl({required this.repository});

  @override
  Future<Try<IaBellaDataEntity>> call(IaBellaSendMessageParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.sendMessage(params.condominiumId, params.userInput);
  }

  Failure? _validate(IaBellaSendMessageParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.userInput.question == null) return InvalidParamFailure();
    if (param.userInput.question!.isEmpty) return InvalidParamFailure();
    return null;
  }
}
