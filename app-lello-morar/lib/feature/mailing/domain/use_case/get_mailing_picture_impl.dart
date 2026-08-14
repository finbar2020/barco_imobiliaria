import 'package:morar/feature/mailing/domain/repository/mailing_repository.dart';

import 'package:essentials/essentials.dart';

class GetMailingPictureUseCase
    extends UseCase<Uint8List?, GetMailingPictureParams> {
  final MailingRepository repository;

  GetMailingPictureUseCase({required this.repository});
  @override
  Future<Try<Uint8List?>> call(GetMailingPictureParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPicture(params.hash);
  }

  Failure? _validate(GetMailingPictureParams params) {
    if (params.hash.isEmpty) return InvalidParamFailure();
    return null;
  }
}

class GetMailingPictureParams {
  final String hash;
  GetMailingPictureParams({
    required this.hash,
  });
}
