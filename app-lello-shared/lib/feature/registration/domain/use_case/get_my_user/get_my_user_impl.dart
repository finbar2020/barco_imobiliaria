part of shared_features;

class GetMyUserImpl extends GetMyUser {
  final RegistrationRepository repository;

  GetMyUserImpl({required this.repository});

  @override
  Future<Try<RegistrationLelloUser>> call(String cpf) async {
    final error = _validate(cpf);
    if (error != null) {
      return Rejection(error);
    }

    final result =
        await repository.get(cpf.replaceAll(new RegExp(r'[^0-9]'), ''));
    return result;
  }

  Failure? _validate(String cpf) {
    if (cpf.isEmpty) return InvalidParamFailure();
    return null;
  }
}
