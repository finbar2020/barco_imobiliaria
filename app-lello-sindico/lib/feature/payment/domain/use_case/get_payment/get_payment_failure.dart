import 'package:essentials/essentials.dart';

abstract class GetPaymentFailure extends Failure {}

class GetPaymentUnknownProvider extends GetPaymentFailure {
  GetPaymentUnknownProvider();
}

class GetPaymentAlreadyRegisteredFailure extends GetPaymentFailure {
  GetPaymentAlreadyRegisteredFailure();
}
