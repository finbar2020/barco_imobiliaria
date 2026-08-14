import 'package:essentials/essentials.dart';

abstract class InsertSubUserFailures extends KnownFailure {
  InsertSubUserFailures(super.code, super.err);
}

class InsertSubUserConflictFailure extends InsertSubUserFailures {
  InsertSubUserConflictFailure(super.code, super.err);
}
