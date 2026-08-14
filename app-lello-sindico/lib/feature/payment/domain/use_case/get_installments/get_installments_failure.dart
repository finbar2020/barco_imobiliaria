import 'package:essentials/essentials.dart';

abstract class GetPaymentFailure extends Failure {}

class GetPaymentUnknownProvider extends GetPaymentFailure {}

class GetPaymentAlreadyRegisteredFailure extends GetPaymentFailure {}
