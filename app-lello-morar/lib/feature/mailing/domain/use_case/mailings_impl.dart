import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:morar/feature/mailing/domain/repository/mailing_repository.dart';
import 'package:morar/feature/mailing/domain/use_case/mailings.dart';

class MailingUseCaseImpl extends MailingUseCase {
  final MailingRepository repository;

  MailingUseCaseImpl({required this.repository});
  @override
  Future<Try<Paginator>> call(MailingParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getMailings(params.unityId,
        showAll: params.showAll);
  }

  Failure? _validate(MailingParams params) {
    if (params.unityId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
