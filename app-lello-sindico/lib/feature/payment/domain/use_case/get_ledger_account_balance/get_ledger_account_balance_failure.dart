import 'package:essentials/essentials.dart';

abstract class GetLedgerAccountBalanceFailure extends Failure {}

class GetLedgerAccountBalanceUnknownProvider
    extends GetLedgerAccountBalanceFailure {}

class GetLedgerAccountBalanceAlreadyRegisteredFailure
    extends GetLedgerAccountBalanceFailure {}
