import 'package:essentials/essentials.dart';

abstract class RegisterPaymentFailure extends Failure {}

class RegisterPaymentInvalidSupplierFailure extends RegisterPaymentFailure {}

class RegisterPaymentInvalidDocumentFailure extends RegisterPaymentFailure {}

class RegisterPaymentInvalidValueFailure extends RegisterPaymentFailure {}

class RegisterPaymentInvalidExpirationFailure extends RegisterPaymentFailure {}

class RegisterPaymentInvalidAccountFailure extends RegisterPaymentFailure {}

class RegisterPaymentInvalidInstallmentsFailure extends RegisterPaymentFailure {
}
