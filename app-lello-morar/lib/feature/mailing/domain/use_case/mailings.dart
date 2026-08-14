import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';

abstract class MailingUseCase extends UseCase<Paginator, MailingParams> {}

class MailingParams {
  final String unityId;
  final bool showAll;

  MailingParams({required this.unityId, this.showAll = false});
}
