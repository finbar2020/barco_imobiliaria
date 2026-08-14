abstract class Failure {
  final dynamic error;
  final String? code;

  Failure({this.code, this.error});

  @override
  bool operator ==(other) =>
      other is Failure && other.code == code && other.error == error;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}

class UnknownFailure extends Failure {
  static final String _code = "UNKNOWN";
  UnknownFailure(dynamic err) : super(code: _code, error: err);
}

class UnknownProvider extends Failure {
  static final String _code = "UNKNOWNPROVIDER";
  UnknownProvider(dynamic err) : super(code: _code, error: err);
}

class KnownFailure extends Failure {
  final String? message;
  KnownFailure(String code, dynamic err, {this.message})
      : super(code: code, error: err);
  @override
  String toString() {
    return "code: $code - err: $error - message: $message";
  }
}

class ServerConnectionFailure extends Failure {}

class InvalidDataOriginFailure extends Failure {}

class InvalidParamFailure extends Failure {}
