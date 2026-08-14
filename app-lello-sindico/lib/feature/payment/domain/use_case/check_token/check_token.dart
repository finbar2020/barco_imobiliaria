import 'package:essentials/base/use_case.dart';

abstract class CheckToken extends UseCase<bool, CheckTokenParam> {}

class CheckTokenParam {
  final String condominiumId;
  final int tokenId;
  final int value;

  CheckTokenParam({
    required this.condominiumId,
    required this.tokenId,
    required this.value,
  });
}
