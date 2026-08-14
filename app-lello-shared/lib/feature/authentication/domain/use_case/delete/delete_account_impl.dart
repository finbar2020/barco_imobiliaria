part of shared_features;

class DeleteAccountImpl extends DeleteAccount {
  final AccessTokenRepository repository;
  DeleteAccountImpl({required this.repository});

  @override
  Future<Try<String?>> call() async {
    return repository.deleteAccount();
  }
}
