part of shared_features;

class RegisterImpl extends Register {
  final RegistrationRepository repository;

  RegisterImpl({
    required this.repository,
  });

  @override
  Future<Try<Registration>> call(Registration params) async {
    final error = _validate(params);
    if (error != null) {
      return Rejection(error);
    }

    return await repository.post(params);
  }

  Failure? _validate(Registration params) {
    if (params.cpf == null)
      return RegistrationMissingRequiredDataFailure("cpf");
    if (params.cpf!.isEmpty)
      return RegistrationMissingRequiredDataFailure("cpf");
    if (params.password == null)
      return RegistrationMissingRequiredDataFailure("password");
    if (params.password!.isEmpty)
      return RegistrationMissingRequiredDataFailure("password");
    return null;
  }
}
