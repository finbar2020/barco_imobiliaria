import 'package:essentials/base/use_case.dart';

abstract class UpdateLedgerAccount
    extends UseCase<bool, UpdateLedgerAccountParam> {}

class UpdateLedgerAccountParam {
  final String condominiumId;
  final int idLancamento;
  final int idContaContabil;

  UpdateLedgerAccountParam({
    required this.condominiumId,
    required this.idLancamento,
    required this.idContaContabil,
  });
}
